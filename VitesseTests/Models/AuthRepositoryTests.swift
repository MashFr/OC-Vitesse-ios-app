//
//  AuthRepositoryTests.swift
//  Vitesse
//
//  Created by Tony Stark on 13/12/2024.
//
import XCTest
@testable import Vitesse

class AuthRepositoryTests: XCTestCase {
    private var authRepository: AuthRepository!
    private var apiService: APIService!
    private var keychainService: KeychainService!

    override func setUp() {
        super.setUp()

        // Configure MockURLProtocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: config)

        // Create dependencies
        apiService = APIService(session: mockSession)
        keychainService = KeychainService()
        authRepository = AuthRepository(apiService: apiService, keychainService: keychainService)
    }

    override func tearDown() {
        authRepository = nil
        apiService = nil
        keychainService = nil
        MockURLProtocol.requestHandler = nil

        super.tearDown()
    }

    // MARK: - Success Cases

    func testAuthenticateUserSuccess() {
        // GIVEN a successful API response for authentication
        let mockAuthResponse = AuthResponse(token: "mock_auth_token", isAdmin: true)
        let mockData = try? JSONEncoder().encode(mockAuthResponse)
        guard let encodedData = mockData else {
            XCTFail("Failed to encode mock AuthResponse")
            return
        }
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.path, "/user/auth")
            return MockResponse(response: mockResponse, data: encodedData, error: nil)
        }

        let expectation = self.expectation(description: "AuthenticateUser should succeed")

        // WHEN authenticateUser is called
        authRepository.authenticateUser(email: "john@example.com", password: "password123") { result in
            // THEN the repository should return the correct data
            switch result {
            case .success(let authResponse):
                XCTAssertEqual(authResponse.token, "mock_auth_token")
                XCTAssertTrue(authResponse.isAdmin)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, got failure with error: \(error)")
            }
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testAuthenticateAndPersistUserSuccess() {
        // GIVEN a successful API response for authentication
        let mockAuthResponse = AuthResponse(token: "mock_auth_token", isAdmin: false)
        let mockData = try? JSONEncoder().encode(mockAuthResponse)
        guard let encodedData = mockData else {
            XCTFail("Failed to encode mock AuthResponse")
            return
        }
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.path, "/user/auth")
            return MockResponse(response: mockResponse, data: encodedData, error: nil)
        }

        let expectation = self.expectation(description: "AuthenticateAndPersistUser should succeed")

        // WHEN authenticateAndPersistUser is called
        authRepository.authenticateAndPersistUser(email: "jane@example.com", password: "securepassword") { result in
            // THEN the repository should return the correct data and persist it
            switch result {
            case .success(let authResponse):
                XCTAssertEqual(authResponse.token, "mock_auth_token")
                XCTAssertFalse(authResponse.isAdmin)

                // Assert persistence
                XCTAssertEqual(try? self.keychainService.retrieve(forKey: "auth_token"), "mock_auth_token")
                XCTAssertEqual(UserDefaults.standard.bool(forKey: "is_admin"), false)

                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, got failure with error: \(error)")
            }
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testRegisterNewUserSuccess() {
        // GIVEN a successful API response for registration
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 201,
            httpVersion: nil,
            headerFields: nil
        )

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.path, "/user/register")
            return MockResponse(response: mockResponse, data: nil, error: nil)
        }

        let expectation = self.expectation(description: "RegisterNewUser should succeed")

        // WHEN registerNewUser is called
        authRepository.registerNewUser(
            email: "jane@example.com",
            password: "securepassword",
            firstName: "Jane",
            lastName: "Doe"
        ) { result in
            // THEN the repository should complete successfully
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, got failure with error: \(error)")
            }
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    // MARK: - Failure Scenarios

    func testAuthenticateUserFailureInvalidCredentials() {
        // GIVEN an unsuccessful API response due to invalid credentials
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil
        )

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.path, "/user/auth")
            return MockResponse(response: mockResponse, data: nil, error: nil)
        }

        let expectation = self.expectation(description: "AuthenticateUser should fail with invalid credentials")

        // WHEN authenticateUser is called
        authRepository.authenticateUser(email: "john@example.com", password: "wrongpassword") { result in
            // THEN the repository should return an error
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testRegisterNewUserFailureEncodingError() {
        // GIVEN invalid data that causes an encoding error
        let oversizedEmail = String(repeating: "a", count: 10_000) // Intentionally oversized to cause an encoding error

        let expectation = self.expectation(description: "RegisterNewUser should fail due to encoding error")

        // WHEN registerNewUser is called
        authRepository.registerNewUser(
            email: oversizedEmail,
            password: "password",
            firstName: "John",
            lastName: "Doe"
        ) { result in
            // THEN the repository should return an encoding error
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
