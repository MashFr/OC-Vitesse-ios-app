//
//  CandidateDetailViewModel.swift
//  Vitesse
//
//  Created by Tony Stark on 26/11/2024.
//

import SwiftUI

class CandidateDetailViewModel: ObservableObject, CandidateDetailViewModelInput, CandidateDetailViewModelOutput {

    private let candidateRepository: CandidateRepository

    // MARK: - Initialization

    init(candidate: Candidate, candidateRepository: CandidateRepository = CandidateRepository()) {
        self.candidate = candidate
        self.candidateRepository = candidateRepository
    }

    // MARK: - OUTPUT

    var output: CandidateDetailViewModelOutput { self }

    @Published private(set) var candidate: Candidate
    @Published private(set) var showErrorAlert: Bool = false
    @Published private(set) var errorAlertMsg: String?

    // MARK: - INPUT

    var input: CandidateDetailViewModelInput { self }

    func markCandidateAsFavorite() {
        candidateRepository.markCandidateAsFavorite(candidateId: candidate.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedCandidate):
                    self.candidate = updatedCandidate
                case .failure:
                    self.showErrorAlert = true
                }
            }
        }
    }

    func updateShowErrorAlert(_ show: Bool) {
        showErrorAlert = show
    }

    func fetchCandidate() {
        candidateRepository.fetchCandidateById(candidateId: candidate.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedCandidate):
                    self.candidate = fetchedCandidate
                case .failure:
//                    self.errorAlertMsg = error.localizedDescription
                    self.showErrorAlert = true
                }
            }
        }
    }
}

protocol CandidateDetailViewModelInput {
    func markCandidateAsFavorite()
    func updateShowErrorAlert(_ show: Bool)
    func fetchCandidate()
}

protocol CandidateDetailViewModelOutput {
    var candidate: Candidate { get }
    var showErrorAlert: Bool { get }
    var errorAlertMsg: String? { get }
}
