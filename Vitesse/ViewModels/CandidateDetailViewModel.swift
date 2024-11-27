//
//  CandidateDetailViewModel.swift
//  Vitesse
//
//  Created by Tony Stark on 26/11/2024.
//

import SwiftUI

class CandidateDetailViewModel: ObservableObject, CandidateDetailViewModelInput, CandidateDetailViewModelOutput {

    // MARK: - OUTPUT

    var output: CandidateDetailViewModelOutput { self }

    @Published private(set) var candidate: Candidate

    // MARK: - INPUT

    var input: CandidateDetailViewModelInput { self }

    func toggleFavorite() {
        candidate.isFavorite.toggle()
    }

    // MARK: - Initialization

    init(candidate: Candidate) {
        self.candidate = candidate
    }
}

protocol CandidateDetailViewModelInput {
    func toggleFavorite()
}

protocol CandidateDetailViewModelOutput {
    var candidate: Candidate { get }
}
