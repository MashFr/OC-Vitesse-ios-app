//
//  LoginViewModel.swift
//  Vitesse
//
//  Created by Tony Stark on 26/11/2024.
//
import Foundation
import Combine

class LoginViewModel: ObservableObject, LoginViewModelInput, LoginViewModelOutput {

    // MARK: - OUTPUT
    var output: LoginViewModelOutput { self }

    @Published private(set) var email: String = ""
    @Published private(set) var password: String = ""
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoginSuccessful: Bool = false

    // MARK: - INPUT
    var input: LoginViewModelInput { self }

    func updateEmail(_ email: String) {
        self.email = email
    }

    func updatePassword(_ password: String) {
        self.password = password
    }

    func login() async {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Email and password are required."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            // Simule un appel à une API pour la connexion
            try await Task.sleep(nanoseconds: 1_000_000_000) // Simulation d'une attente d'API
            if email == "Admin" && password == "Admin" {
                isLoginSuccessful = true
                errorMessage = nil
            } else {
                throw LoginError.invalidCredentials
            }
        } catch {
            isLoginSuccessful = false
            errorMessage = error.localizedDescription
        }
    }
}

protocol LoginViewModelInput {
    func updateEmail(_ email: String)
    func updatePassword(_ password: String)
    func login() async
}

protocol LoginViewModelOutput {
    var email: String { get }
    var password: String { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var isLoginSuccessful: Bool { get }
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
