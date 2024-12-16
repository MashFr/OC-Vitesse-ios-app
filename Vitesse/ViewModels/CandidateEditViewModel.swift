//
//  CandidateEditViewModel.swift
//  Vitesse
//
//  Created by Tony Stark on 26/11/2024.
//
import Foundation

class CandidateEditViewModel: ObservableObject, CandidateEditViewModelInput, CandidateEditViewModelOutput {

    private let candidateRepository: CandidateRepository

    // MARK: - Initializer
    init(candidateRepository: CandidateRepository = CandidateRepository(), candidate: Candidate) {
        self.candidateRepository = candidateRepository
        self.candidate = candidate
    }

    // MARK: - OUTPUT
    var output: CandidateEditViewModelOutput { self }

    @Published private(set) var emailError: CandidateFieldValidationError?
    @Published private(set) var linkedInURLError: CandidateFieldValidationError?
    @Published private(set) var phoneError: CandidateFieldValidationError?

    @Published private(set) var isSaving: Bool = false
    @Published private(set) var showErrorAlert: Bool = false
    @Published private(set) var showSuccessAlert: Bool = false
    @Published private(set) var errorMessage: String?

    @Published var candidate: Candidate

    // MARK: - INPUT
    var input: CandidateEditViewModelInput { self }

    func updateEmail(_ email: String) {
        candidate.email = email
    }

    func updatePhone(_ phone: String) {
        candidate.phone = phone.isEmpty ? nil : phone
    }

    func updateLinkedInURL(_ linkedInURL: String) {
        candidate.linkedinURL = linkedInURL.isEmpty ? nil : URL(string: linkedInURL)
    }

    func updateNote(_ note: String) {
        candidate.note = note.isEmpty ? nil : note
    }

    func updateShowErrorAlert(_ showErrorAlert: Bool) {
        self.showErrorAlert = showErrorAlert
        if !showErrorAlert {
            errorMessage = nil
        }
    }

    func updateShowSuccessAlert(_ showSuccessAlert: Bool) {
        self.showSuccessAlert = showSuccessAlert
    }

    func saveCandidate() {
        isSaving = true

        guard validateAllFields() else {
            isSaving = false
            return
        }

        candidateRepository.updateCandidate(candidate: candidate) { result in
            DispatchQueue.main.async {
                self.isSaving = false
                switch result {
                case .success:
                    self.showSuccessAlert = true
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showErrorAlert = true
                }
            }
        }
    }

    // MARK: - Validation

    private func validateEmail() {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        if candidate.email.isEmpty {
            emailError = .emptyField(fieldName: "Email")
        } else if !emailPredicate.evaluate(with: candidate.email) {
            emailError = .invalidEmail
        } else {
            emailError = nil
        }
    }

    private func validatePhone() {
        if let phone = candidate.phone, !phone.isEmpty {
            let phoneRegex = "^\\+?[0-9]{7,15}$"
            let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            if !phonePredicate.evaluate(with: phone) {
                phoneError = .invalidPhone
            } else {
                phoneError = nil
            }
        } else {
            phoneError = nil // Champ facultatif
        }
    }

    private func validateLinkedInURL() {
        if let linkedInURL = candidate.linkedinURL?.absoluteString, !linkedInURL.isEmpty {

            if URL(string: linkedInURL) == nil || !linkedInURL.lowercased().contains("linkedin.com") {
                linkedInURLError = .invalidURL
            } else {
                linkedInURLError = nil
            }
        } else {
            linkedInURLError = nil // Champ facultatif
        }
    }

    private func validateAllFields() -> Bool {
        validateEmail()
        validatePhone()
        validateLinkedInURL()

        return emailError == nil &&
               phoneError == nil &&
               linkedInURLError == nil
    }
}

protocol CandidateEditViewModelInput {
    func updateEmail(_ email: String)
    func updatePhone(_ phone: String)
    func updateLinkedInURL(_ linkedInURL: String)
    func updateNote(_ note: String)
    func saveCandidate()
    func updateShowErrorAlert(_ showErrorAlert: Bool)
    func updateShowSuccessAlert(_ showErrorAlert: Bool)
}

protocol CandidateEditViewModelOutput {
    var candidate: Candidate { get }

    var emailError: CandidateFieldValidationError? { get }
    var linkedInURLError: CandidateFieldValidationError? { get }
    var phoneError: CandidateFieldValidationError? { get }

    var isSaving: Bool { get }
    var showErrorAlert: Bool { get }
    var showSuccessAlert: Bool { get }
    var errorMessage: String? { get }
}

enum CandidateFieldValidationError: LocalizedError, Equatable {
    case emptyField(fieldName: String)
    case invalidEmail
    case invalidURL
    case invalidPhone

    var errorDescription: String? {
        switch self {
        case .emptyField(let fieldName):
            return "\(fieldName) is required."
        case .invalidEmail:
            return "Enter a valid email address."
        case .invalidURL:
            return "Enter a valid LinkedIn URL."
        case .invalidPhone:
            return "Enter a valid phone number."
        }
    }
}
