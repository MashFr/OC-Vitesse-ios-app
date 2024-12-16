//
//  CandidateRepository.swift
//  Vitesse
//
//  Created by Tony Stark on 03/12/2024.
//
import Foundation

class CandidateRepository {
    private let apiService: APIService
    private let keychainService: KeychainService

    init(apiService: APIService = APIService(), keychainService: KeychainService = KeychainService()) {
        self.apiService = apiService
        self.keychainService = keychainService
    }

    // Fetch all candidates
    func fetchCandidates(completion: @escaping (Result<[Candidate], Error>) -> Void) {
        let authToken: String
        do {
            authToken = try keychainService.retrieve(forKey: "auth_token")
        } catch {
            completion(.failure(error))
            return
        }

        let endpoint = APIEndpoint.getCandidates // L'endpoint pour récupérer les candidats
        let headers = HTTPHeaders(forJSON: true, authToken: authToken)

        apiService.fetchAndDecode(
            endpoint: endpoint,
            method: .GET,
            headers: headers
        ) { (result: Result<[CandidateDTO], Error>) in
            switch result {
            case .success(let candidatesDTO):
                let candidates = candidatesDTO.map { Candidate(from: $0) }
                completion(.success(candidates))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Fetch a specific candidate by ID
    func fetchCandidateById(candidateId: UUID, completion: @escaping (Result<Candidate, Error>) -> Void) {
        let authToken: String
        do {
            authToken = try keychainService.retrieve(forKey: "auth_token")
        } catch {
            completion(.failure(error))
            return
        }

        let endpoint = APIEndpoint.getCandidateDetail(id: candidateId.uuidString)
        let headers = HTTPHeaders(forJSON: true, authToken: authToken)

        apiService.fetchAndDecode(
            endpoint: endpoint,
            method: .GET,
            headers: headers
        ) { (result: Result<CandidateDTO, Error>) in
            switch result {
            case .success(let candidateDTO):
                let candidate = Candidate(from: candidateDTO)
                completion(.success(candidate))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Create a new candidate
    func createCandidate(candidate: Candidate, completion: @escaping (Result<Candidate, Error>) -> Void) {
        let authToken: String
        do {
            authToken = try keychainService.retrieve(forKey: "auth_token")
        } catch {
            completion(.failure(error))
            return
        }

        let endpoint = APIEndpoint.createCandidate
        let headers = HTTPHeaders(forJSON: true, authToken: authToken)
        let candidateDTO = candidate.toDTO()

        do {
            let body = try JSONEncoder().encode(candidateDTO)
            apiService.fetchAndDecode(
                endpoint: endpoint,
                method: .POST,
                body: body,
                headers: headers
            ) { (result: Result<CandidateDTO, Error>) in
                switch result {
                case .success(let createdCandidateDTO):
                    let createdCandidate = Candidate(from: createdCandidateDTO)
                    completion(.success(createdCandidate))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    // Update an existing candidate
    func updateCandidate(candidate: Candidate, completion: @escaping (Result<Candidate, Error>) -> Void) {
        let authToken: String
        do {
            authToken = try keychainService.retrieve(forKey: "auth_token")
        } catch {
            completion(.failure(error))
            return
        }

        let endpoint = APIEndpoint.updateCandidate(id: candidate.id.uuidString)
        let headers = HTTPHeaders(forJSON: true, authToken: authToken)
        let candidateDTO = candidate.toDTO()

        do {
            let body = try JSONEncoder().encode(candidateDTO)
            apiService.fetchAndDecode(
                endpoint: endpoint,
                method: .PUT,
                body: body,
                headers: headers
            ) { (result: Result<CandidateDTO, Error>) in
                switch result {
                case .success(let updatedCandidateDTO):
                    let updatedCandidate = Candidate(from: updatedCandidateDTO)
                    completion(.success(updatedCandidate))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    // Delete a candidate
    func deleteCandidate(candidateId: UUID, completion: @escaping (Result<Data?, Error>) -> Void) {
        let authToken: String
        do {
            authToken = try keychainService.retrieve(forKey: "auth_token")
        } catch {
            completion(.failure(error))
            return
        }

        let endpoint = APIEndpoint.deleteCandidate(id: candidateId.uuidString)
        let headers = HTTPHeaders(forJSON: true, authToken: authToken)

        apiService.fetch(
            endpoint: endpoint,
            method: .DELETE,
            headers: headers
        ) { result in
            completion(result)
        }
    }

    // Mark a candidate as favorite (only for admin)
    func markCandidateAsFavorite(candidateId: UUID, completion: @escaping (Result<Candidate, Error>) -> Void) {
        let authToken: String
        do {
            authToken = try keychainService.retrieve(forKey: "auth_token")
        } catch {
            completion(.failure(error))
            return
        }

        let endpoint = APIEndpoint.toggleFavoriteCandidate(id: candidateId.uuidString)
        let headers = HTTPHeaders(forJSON: true, authToken: authToken)

        apiService.fetchAndDecode(
            endpoint: endpoint,
            method: .POST,
            headers: headers
        ) { (result: Result<CandidateDTO, Error>) in
            switch result {
            case .success(let candidateDTO):
                let candidate = Candidate(from: candidateDTO)
                completion(.success(candidate))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
