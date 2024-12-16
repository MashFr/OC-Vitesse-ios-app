//
//  RegisterViewModel.swift
//  Vitesse
//
//  Created by Tony Stark on 27/11/2024.
//
import Foundation
import Combine

class RegisterViewModel: ObservableObject, RegisterViewModelInput, RegisterViewModelOutput {

    private let userRepository: UserRepository

    // MARK: - Initializer
    init(userRepository: UserRepository = UserRepository()) {
        self.userRepository = userRepository
    }

    // MARK: - OUTPUT
    var output: RegisterViewModelOutput { self }

    @Published private(set) var firstName: String = ""
    @Published private(set) var lastName: String = ""
    @Published private(set) var emailAddress: String = ""
    @Published private(set) var password: String = ""
    @Published private(set) var confirmPassword: String = ""

    @Published private(set) var firstNameError: RegisterFieldValidationError?
    @Published private(set) var lastNameError: RegisterFieldValidationError?
    @Published private(set) var emailError: RegisterFieldValidationError?
    @Published private(set) var passwordError: RegisterFieldValidationError?
    @Published private(set) var confirmPasswordError: RegisterFieldValidationError?

    @Published private(set) var isLoading: Bool = false
    @Published private(set) var showSuccessAlert: Bool = false {
        didSet {
            print("showSuccessAlert updated to \(showSuccessAlert)")
        }
    }
    @Published private(set) var showErrorAlert: Bool = false
    @Published private(set) var errorMessage: String?

    // MARK: - INPUT
    var input: RegisterViewModelInput { self }

    func updateFirstName(_ firstName: String) {
        self.firstName = firstName
    }

    func updateLastName(_ lastName: String) {
        self.lastName = lastName
    }

    func updateEmailAddress(_ emailAddress: String) {
        self.emailAddress = emailAddress
    }

    func updatePassword(_ password: String) {
        self.password = password
    }

    func updateConfirmPassword(_ confirmPassword: String) {
        self.confirmPassword = confirmPassword
    }

    func updateShowErrorAlert(_ showErrorAlert: Bool) {
        self.showErrorAlert = showErrorAlert
        if showErrorAlert == false {
            errorMessage = nil
        }
    }

    func updateShowSuccessAlert(_ showSuccessAlert: Bool) {
        self.showSuccessAlert = showSuccessAlert
    }

    func register() {
        print(" at register showSuccessAlert = \(self.showSuccessAlert)" )
        self.isLoading = true

        guard validateAllFields() else {
            self.isLoading = false
            return
        }

        userRepository.registerNewUser(
            email: emailAddress,
            password: password,
            firstName: firstName,
            lastName: lastName
        ) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.showSuccessAlert = true
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    self.showErrorAlert = true
                }
            }
        }
    }
}

protocol RegisterViewModelInput {
    func updateFirstName(_ firstName: String)
    func updateLastName(_ lastName: String)
    func updateEmailAddress(_ emailAddress: String)
    func updatePassword(_ password: String)
    func updateConfirmPassword(_ confirmPassword: String)
    func updateShowErrorAlert(_ showErrorAlert: Bool)
    func updateShowSuccessAlert(_ showSuccessAlert: Bool)
    func register()
}

protocol RegisterViewModelOutput {
    var firstName: String { get }
    var lastName: String { get }
    var emailAddress: String { get }
    var password: String { get }
    var confirmPassword: String { get }

    var firstNameError: RegisterFieldValidationError? { get }
    var lastNameError: RegisterFieldValidationError? { get }
    var emailError: RegisterFieldValidationError? { get }
    var passwordError: RegisterFieldValidationError? { get }
    var confirmPasswordError: RegisterFieldValidationError? { get }

    var isLoading: Bool { get }
    var showSuccessAlert: Bool { get }
    var showErrorAlert: Bool { get }
    var errorMessage: String? { get }
}

enum RegisterFieldValidationError: LocalizedError, Equatable {
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

    private func validateFirstName() {
        firstNameError = firstName.isEmpty ? .emptyField(fieldName: "First Name") : nil
    }

    private func validateLastName() {
        lastNameError = lastName.isEmpty ? .emptyField(fieldName: "Last Name") : nil
    }

    private func validateEmailAddress() {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        if emailAddress.isEmpty {
            emailError = .emptyField(fieldName: "Email")
        } else if !emailPredicate.evaluate(with: emailAddress) {
            emailError = .invalidEmail
        } else {
            emailError = nil
        }
    }

    private func validatePassword() {
        if password.isEmpty {
            passwordError = .emptyField(fieldName: "Password")
        } else if password.count < 6 {
            passwordError = .shortPassword(minLength: 6)
        } else {
            passwordError = nil
        }
    }

    private func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordError = .emptyField(fieldName: "Confirm Password")
        } else if confirmPassword != password {
            confirmPasswordError = .passwordsDoNotMatch
        } else {
            confirmPasswordError = nil
        }
    }

    private func validateAllFields() -> Bool {
        validateFirstName()
        validateLastName()
        validateEmailAddress()
        validatePassword()
        validateConfirmPassword()

        return firstNameError == nil &&
               lastNameError == nil &&
               emailError == nil &&
               passwordError == nil &&
               confirmPasswordError == nil
    }
}
