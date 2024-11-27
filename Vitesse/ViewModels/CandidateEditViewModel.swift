//
//  CandidateEditViewModel.swift
//  Vitesse
//
//  Created by Tony Stark on 26/11/2024.
//

import Foundation
import Combine

class CandidateEditViewModel: ObservableObject, CandidateEditViewModelInput, CandidateEditViewModelOutput {

    // MARK: - Initialization

    init(candidate: Candidate) {
        self.candidate = candidate
    }

    // MARK: - OUTPUT

    var output: CandidateEditViewModelOutput { self }

    @Published private(set) var candidate: Candidate
    @Published private(set) var errorMessage: String?
    @Published private(set) var showErrorAlert: Bool = false
    @Published private(set) var isSaving: Bool = false

    // MARK: - INPUT

    var input: CandidateEditViewModelInput { self }

    func updatePhone(_ phone: String) {
        candidate.phone = phone
    }

    func updateEmail(_ email: String) {
        candidate.email = email
    }

    func updateLinkedInURL(_ linkedInURL: String) {
        if let url = URL(string: linkedInURL), !linkedInURL.isEmpty {
            candidate.linkedinURL = url
        } else {
            candidate.linkedinURL = nil
        }
    }

    func updateNote(_ note: String) {
        candidate.note = note.isEmpty ? nil : note
    }

    func saveCandidate() async {
        isSaving = true
        defer { isSaving = false }

        do {
            // Simuler une logique de sauvegarde (par ex. appel à une API ou persistance locale)
            try await Task.sleep(nanoseconds: 1_000_000_000) // Simule un délai
            print("Candidate saved: \(candidate)")
        } catch {
            errorMessage = "Failed to save candidate: \(error.localizedDescription)"
            showErrorAlert = true
        }
    }

    func updateShowErrorAlert(_ isErrorAlertShown: Bool) {
        showErrorAlert = isErrorAlertShown
    }
}

protocol CandidateEditViewModelInput {
    func updatePhone(_ phone: String)
    func updateEmail(_ email: String)
    func updateLinkedInURL(_ linkedInURL: String)
    func updateNote(_ note: String)
    func saveCandidate() async
    func updateShowErrorAlert(_ isErrorAlertShown: Bool)
}

protocol CandidateEditViewModelOutput {
    var candidate: Candidate { get }
    var isSaving: Bool { get }
    var errorMessage: String? { get }
    var showErrorAlert: Bool { get }
}
