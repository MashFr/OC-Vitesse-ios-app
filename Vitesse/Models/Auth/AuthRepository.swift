//
//  AuthRepository.swift
//  Vitesse
//
//  Created by Tony Stark on 04/12/2024.
//
import Foundation

class AuthRepository {
    private let apiService: APIService
    private let keychainService: KeychainService

    init(apiService: APIService = APIService(), keychainService: KeychainService = KeychainService()) {
        self.apiService = apiService
        self.keychainService = keychainService
    }

    // MARK: - Authenticate User
    func authenticateUser(
        email: String,
        password: String,
        completion: @escaping (Result<AuthResponse, Error>) -> Void
    ) {
        let endpoint = APIEndpoint.authenticate
        let body = AuthBody(email: email, password: password)
        let headers = HTTPHeaders(forJSON: true)

        do {
            let bodyData = try JSONEncoder().encode(body)
            apiService.fetchAndDecode(
                endpoint: endpoint,
                method: .POST,
                body: bodyData,
                headers: headers
            ) { (result: Result<AuthResponse, Error>) in
                completion(result)
            }
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Authenticate and Persist User Info
    func authenticateAndPersistUser(
        email: String,
        password: String,
        completion: @escaping (Result<AuthResponse, Error>) -> Void
    ) {
        // Call the private authenticateUser method
        authenticateUser(email: email, password: password) { result in
            switch result {
            case .success(let authResponse):
                do {
                    // Store the token in the Keychain
                    try self.keychainService.saveOrUpdate(authResponse.token, forKey: "auth_token")

                    // Store isAdmin in UserDefaults
                    UserDefaults.standard.set(authResponse.isAdmin, forKey: "is_admin")

                    completion(.success(authResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Register New User
    func registerNewUser(
        email: String,
        password: String,
        firstName: String,
        lastName: String,
        completion: @escaping (Result<Data?, Error>) -> Void
    ) {
        let endpoint = APIEndpoint.register
        let body = RegisterBody(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        )
        let headers = HTTPHeaders(forJSON: true)

        do {
            let bodyData = try JSONEncoder().encode(body)
            apiService.fetch(
                endpoint: endpoint,
                method: .POST,
                body: bodyData,
                headers: headers,
                completion: completion
            )
        } catch {
            completion(.failure(error))
        }
    }
}
