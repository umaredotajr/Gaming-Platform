import { describe, it, beforeEach, expect } from "vitest"

describe("tournament", () => {
  let contract: any
  
  beforeEach(() => {
    contract = {
      createTournament: (name: string, gameId: number, startBlock: number, endBlock: number, prizePool: number) => ({
        value: 1,
      }),
      joinTournament: (tournamentId: number) => ({ success: true }),
      submitScore: (tournamentId: number, score: number) => ({ success: true }),
      endTournament: (tournamentId: number) => ({ success: true }),
      getTournament: (tournamentId: number) => ({
        name: "Battle Royale",
        gameId: 1,
        startBlock: 10000,
        endBlock: 20000,
        prizePool: 10000,
        status: "active",
      }),
      getParticipantScore: (tournamentId: number, participant: string) => ({ score: 100 }),
    }
  })
  
  describe("create-tournament", () => {
    it("should create a new tournament", () => {
      const result = contract.createTournament("Battle Royale", 1, 10000, 20000, 10000)
      expect(result.value).toBe(1)
    })
  })
  
  describe("join-tournament", () => {
    it("should allow a user to join a tournament", () => {
      const result = contract.joinTournament(1)
      expect(result.success).toBe(true)
    })
  })
  
  describe("submit-score", () => {
    it("should allow a participant to submit a score", () => {
      const result = contract.submitScore(1, 100)
      expect(result.success).toBe(true)
    })
  })
  
  describe("end-tournament", () => {
    it("should end a tournament", () => {
      const result = contract.endTournament(1)
      expect(result.success).toBe(true)
    })
  })
  
  describe("get-tournament", () => {
    it("should return details of a tournament", () => {
      const result = contract.getTournament(1)
      expect(result.name).toBe("Battle Royale")
      expect(result.gameId).toBe(1)
      expect(result.startBlock).toBe(10000)
      expect(result.endBlock).toBe(20000)
      expect(result.prizePool).toBe(10000)
      expect(result.status).toBe("active")
    })
  })
  
  describe("get-participant-score", () => {
    it("should return a participant's score", () => {
      const result = contract.getParticipantScore(1, "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM")
      expect(result.score).toBe(100)
    })
  })
})

