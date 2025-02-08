;; Tournament Contract

(define-map tournaments
  { tournament-id: uint }
  {
    name: (string-ascii 64),
    game-id: uint,
    start-block: uint,
    end-block: uint,
    prize-pool: uint,
    status: (string-ascii 20)
  }
)

(define-map participants
  { tournament-id: uint, participant: principal }
  { score: uint }
)

(define-data-var tournament-nonce uint u0)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_NOT_FOUND (err u404))
(define-constant ERR_ALREADY_STARTED (err u409))
(define-constant ERR_NOT_ACTIVE (err u410))

(define-public (create-tournament (name (string-ascii 64)) (game-id uint) (start-block uint) (end-block uint) (prize-pool uint))
  (let
    (
      (tournament-id (+ (var-get tournament-nonce) u1))
    )
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (map-set tournaments
      { tournament-id: tournament-id }
      {
        name: name,
        game-id: game-id,
        start-block: start-block,
        end-block: end-block,
        prize-pool: prize-pool,
        status: "upcoming"
      }
    )
    (var-set tournament-nonce tournament-id)
    (ok tournament-id)
  )
)

(define-public (join-tournament (tournament-id uint))
  (let
    (
      (tournament (unwrap! (map-get? tournaments { tournament-id: tournament-id }) ERR_NOT_FOUND))
    )
    (asserts! (is-eq (get status tournament) "upcoming") ERR_ALREADY_STARTED)
    (map-set participants
      { tournament-id: tournament-id, participant: tx-sender }
      { score: u0 }
    )
    (ok true)
  )
)

(define-public (submit-score (tournament-id uint) (score uint))
  (let
    (
      (tournament (unwrap! (map-get? tournaments { tournament-id: tournament-id }) ERR_NOT_FOUND))
    )
    (asserts! (is-eq (get status tournament) "active") ERR_NOT_ACTIVE)
    (map-set participants
      { tournament-id: tournament-id, participant: tx-sender }
      { score: score }
    )
    (ok true)
  )
)

(define-public (end-tournament (tournament-id uint))
  (let
    (
      (tournament (unwrap! (map-get? tournaments { tournament-id: tournament-id }) ERR_NOT_FOUND))
    )
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (>= block-height (get end-block tournament)) ERR_NOT_ACTIVE)
    (map-set tournaments
      { tournament-id: tournament-id }
      (merge tournament { status: "ended" })
    )
    (ok true)
  )
)

(define-read-only (get-tournament (tournament-id uint))
  (map-get? tournaments { tournament-id: tournament-id })
)

(define-read-only (get-participant-score (tournament-id uint) (participant principal))
  (map-get? participants { tournament-id: tournament-id, participant: participant })
)
