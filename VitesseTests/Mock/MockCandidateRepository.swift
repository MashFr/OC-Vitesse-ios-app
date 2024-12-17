//
//  MockCandidateRepository.swift
//  Vitesse
//
//  Created by Tony Stark on 16/12/2024.
//
@testable import Vitesse
import Foundation

final class MockCandidateRepository: CandidateRepository {
    var fetchCandidatesResult: Result<[Candidate], Error>?
    var deleteCandidateResult: Result<Data?, Error>?
    var fetchCandidateByIdResult: Result<Candidate, Error>?
    var markCandidateAsFavoriteResult: Result<Candidate, Error>?
    var updateCandidateResult: Result<Candidate, Error>?

    override func fetchCandidates(completion: @escaping (Result<[Candidate], Error>) -> Void) {
        if let result = fetchCandidatesResult {
            completion(result)
        }
    }

    override func fetchCandidateById(candidateId: UUID, completion: @escaping (Result<Candidate, Error>) -> Void) {
        if let result = fetchCandidateByIdResult {
            completion(result)
        }
    }

    override func deleteCandidate(candidateId: UUID, completion: @escaping (Result<Data?, Error>) -> Void) {
        if let result = deleteCandidateResult {
            completion(result)
        }
    }

    override func markCandidateAsFavorite(candidateId: UUID, completion: @escaping (Result<Candidate, Error>) -> Void) {
        if let result = markCandidateAsFavoriteResult {
            completion(result)
        }
    }

    override func updateCandidate(candidate: Candidate, completion: @escaping (Result<Candidate, Error>) -> Void) {
        if let result = updateCandidateResult {
            completion(result)
        }
    }
}
