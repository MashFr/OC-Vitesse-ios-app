//
//  LoginViewModel.swift
//  Vitesse
//
//  Created by Tony Stark on 26/11/2024.
//
import Foundation
import Combine

class LoginViewModel: ObservableObject, LoginViewModelInput, LoginViewModelOutput {

    private let authRepository: AuthRepository

    // MARK: - Initializer
    init(authRepository: AuthRepository = AuthRepository()) {
        self.authRepository = authRepository
    }

    // MARK: - OUTPUT
    var output: LoginViewModelOutput { self }

    @Published private(set) var email: String = ""
    @Published private(set) var password: String = ""

    @Published private(set) var emailError: LoginFieldValidationError?
    @Published private(set) var passwordError: LoginFieldValidationError?
    @Published private(set) var loginError: LoginError?

    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isLoginSuccessful: Bool = false

    // MARK: - INPUT
    var input: LoginViewModelInput { self }

    func updateEmail(_ email: String) {
        self.email = email
    }

    func updatePassword(_ password: String) {
        self.password = password
    }

    func login() {
        DispatchQueue.main.async {
            self.isLoading = true
            self.isLoginSuccessful = false
            self.loginError = nil
            self.validateAllFields()
        }

        guard emailError == nil, !email.isEmpty,
              passwordError == nil, !password.isEmpty
        else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            return
        }

        authRepository.authenticateAndPersistUser(
            email: email,
            password: password
        ) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isLoginSuccessful = true
                }
            case .failure:
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isLoginSuccessful = false
                    self.loginError = LoginError.invalidCredentials
                }
            }
        }
    }
}

protocol LoginViewModelInput {
    func updateEmail(_ email: String)
    func updatePassword(_ password: String)
    func login()
}

protocol LoginViewModelOutput {
    var email: String { get }
    var password: String { get }

    var emailError: LoginFieldValidationError? { get }
    var passwordError: LoginFieldValidationError? { get }
    var loginError: LoginError? { get }

    var isLoading: Bool { get }
    var isLoginSuccessful: Bool { get }
}

enum LoginFieldValidationError: LocalizedError, Equatable {
    case emptyField(fieldName: String)

    var errorDescription: String? {
        switch self {
        case .emptyField(let fieldName):
            return "\(fieldName) is required."
        }
    }
}

enum LoginError: LocalizedError {
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password. Please try again."
        }
    }
}

extension LoginViewModel {
    // MARK: - Validation Methods
    private func validateEmail() {
        if email.isEmpty {
            emailError = .emptyField(fieldName: "Email")
        } else {
            emailError = nil
        }
    }

    private func validatePassword() {
        if password.isEmpty {
            passwordError = .emptyField(fieldName: "Password")
        } else {
            passwordError = nil
        }
    }

    private func validateAllFields() {
        validateEmail()
        validatePassword()
    }
}
