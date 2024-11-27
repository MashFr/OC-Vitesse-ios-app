//
//  RegisterViewModel.swift
//  Vitesse
//
//  Created by Tony Stark on 27/11/2024.
//
import Foundation
import Combine

class RegisterViewModel: ObservableObject, RegisterViewModelInput, RegisterViewModelOutput {

    // MARK: - OUTPUT
    var output: RegisterViewModelOutput { self }

    @Published private(set) var firstName: String = ""
    @Published private(set) var lastName: String = ""
    @Published private(set) var emailAddress: String = ""
    @Published private(set) var password: String = ""
    @Published private(set) var confirmPassword: String = ""

    @Published private(set) var firstNameError: FieldValidationError?
    @Published private(set) var lastNameError: FieldValidationError?
    @Published private(set) var emailError: FieldValidationError?
    @Published private(set) var passwordError: FieldValidationError?
    @Published private(set) var confirmPasswordError: FieldValidationError?

    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isRegistrationSuccessful: Bool = false

    // MARK: - INPUT
    var input: RegisterViewModelInput { self }

    func updateFirstName(_ firstName: String) {
        self.firstName = firstName
//        validateFirstName()
    }

    func updateLastName(_ lastName: String) {
        self.lastName = lastName
//        validateLastName()
    }

    func updateEmailAddress(_ emailAddress: String) {
        self.emailAddress = emailAddress
//        validateEmailAddress()
    }

    func updatePassword(_ password: String) {
        self.password = password
//        validatePassword()
    }

    func updateConfirmPassword(_ confirmPassword: String) {
        self.confirmPassword = confirmPassword
//        validateConfirmPassword()
    }

    func register() async {
        validateAllFields()

        guard firstNameError == nil,
              lastNameError == nil,
              emailError == nil,
              passwordError == nil,
              confirmPasswordError == nil else { return }

        isLoading = true
        defer { isLoading = false }

        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isRegistrationSuccessful = true
    }
}

protocol RegisterViewModelInput {
    func updateFirstName(_ firstName: String)
    func updateLastName(_ lastName: String)
    func updateEmailAddress(_ emailAddress: String)
    func updatePassword(_ password: String)
    func updateConfirmPassword(_ confirmPassword: String)
    func register() async
}

protocol RegisterViewModelOutput {
    var firstName: String { get }
    var lastName: String { get }
    var emailAddress: String { get }
    var password: String { get }
    var confirmPassword: String { get }

    var firstNameError: FieldValidationError? { get }
    var lastNameError: FieldValidationError? { get }
    var emailError: FieldValidationError? { get }
    var passwordError: FieldValidationError? { get }
    var confirmPasswordError: FieldValidationError? { get }

    var isLoading: Bool { get }
    var isRegistrationSuccessful: Bool { get }
}

enum FieldValidationError: LocalizedError {
    case emptyField(fieldName: String)
    case invalidEmail
    case shortPassword(minLength: Int)
    case passwordsDoNotMatch

    var errorDescription: String? {
        switch self {
        case .emptyField(let fieldName):
            return "\(fieldName) is required."
        case .invalidEmail:
            return "Enter a valid email address."
        case .shortPassword(let minLength):
            return "Password must be at least \(minLength) characters."
        case .passwordsDoNotMatch:
            return "Passwords do not match."
        }
    }
}

extension RegisterViewModel {
    // MARK: - Validation Methods

    func validateFirstName() {
        firstNameError = firstName.isEmpty ? .emptyField(fieldName: "First Name") : nil
    }

    func validateLastName() {
        lastNameError = lastName.isEmpty ? .emptyField(fieldName: "Last Name") : nil
    }

    func validateEmailAddress() {
        if emailAddress.isEmpty {
            emailError = .emptyField(fieldName: "Email")
        } else if !emailAddress.contains("@") {
            emailError = .invalidEmail
        } else {
            emailError = nil
        }
    }

    func validatePassword() {
        if password.isEmpty {
            passwordError = .emptyField(fieldName: "Password")
        } else if password.count < 6 {
            passwordError = .shortPassword(minLength: 6)
        } else {
            passwordError = nil
        }
    }

    func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordError = .emptyField(fieldName: "Confirm Password")
        } else if confirmPassword != password {
            confirmPasswordError = .passwordsDoNotMatch
        } else {
            confirmPasswordError = nil
        }
    }

    func validateAllFields() {
        validateFirstName()
        validateLastName()
        validateEmailAddress()
        validatePassword()
        validateConfirmPassword()
    }
}
