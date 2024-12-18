//
//  MockAuthRepository.swift
//  Vitesse
//
//  Created by Tony Stark on 16/12/2024.
//
import XCTest
@testable import Vitesse

final class MockAuthRepository: AuthRepository {
    var registerSuccess: Bool = false
    var registerError: Error?
    var loginSuccess: Bool = false
    var loginError: Error?

    override func registerNewUser(
        email: String,
        password: String,
        firstName: String,
        lastName: String,
        completion: @escaping (Result<Data?, Error>) -> Void
    ) {
        if registerSuccess {
            completion(.success(nil))
        } else if let error = registerError {
            completion(.failure(error))
        } else {
            completion(.failure(NSError(domain: "Test", code: -1, userInfo: nil)))
        }
    }

    override func authenticateAndPersistUser(
        email: String,
        password: String,
        completion: @escaping (Result<AuthResponse, Error>) -> Void
    ) {
        if loginSuccess {
            let mockAuthResponse = AuthResponse(token: "mock_token", isAdmin: true) // Exemple de données
            completion(.success(mockAuthResponse))
        } else if let error = loginError {
            completion(.failure(error))
        } else {
            completion(.failure(LoginError.invalidCredentials))
        }
    }
}
