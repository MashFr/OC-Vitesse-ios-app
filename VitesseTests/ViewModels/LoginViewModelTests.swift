//
//  LoginViewModelTests.swift
//  VitesseTests
//
//  Created by Tony Stark on 16/12/2024.
//
import XCTest
@testable import Vitesse

final class LoginViewModelTests: XCTestCase {

    private var viewModel: LoginViewModel!
    private var mockUserRepository: MockUserRepository!

    override func setUp() {
        super.setUp()
        mockUserRepository = MockUserRepository()
        viewModel = LoginViewModel(userRepository: mockUserRepository)
    }

    override func tearDown() {
        viewModel = nil
        mockUserRepository = nil
        super.tearDown()
    }

    // MARK: - Field Updates Tests

    func testUpdateEmail() {
        // WHEN
        viewModel.updateEmail("tony.stark@example.com")

        // THEN
        XCTAssertEqual(viewModel.email, "tony.stark@example.com")
    }

    func testUpdatePassword() {
        // WHEN
        viewModel.updatePassword("password123")

        // THEN
        XCTAssertEqual(viewModel.password, "password123")
    }

    // MARK: - Validation Tests

    func testValidateAllFields() {
        // GIVEN
        viewModel.updateEmail("")
        viewModel.updatePassword("")
        mockUserRepository.loginSuccess = false

        let loginExpectation = expectation(description: "Login should Failed")

        // WHEN
        viewModel.login()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // THEN
            XCTAssertNotNil(self.viewModel.emailError)
            XCTAssertEqual(self.viewModel.emailError, .emptyField(fieldName: "Email"))
            XCTAssertNotNil(self.viewModel.passwordError)
            XCTAssertEqual(self.viewModel.passwordError, .emptyField(fieldName: "Password"))
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertFalse(self.viewModel.isLoginSuccessful)
            loginExpectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    // MARK: - Login Success and Failure Tests

    func testLoginSuccess() {
        // GIVEN
        viewModel.updateEmail("tony.stark@example.com")
        viewModel.updatePassword("password123")
        mockUserRepository.loginSuccess = true

        let loginExpectation = expectation(description: "Login should succeed")

        // WHEN
        viewModel.login()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // THEN
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertTrue(self.viewModel.isLoginSuccessful)
            XCTAssertNil(self.viewModel.loginError)
            loginExpectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testLoginFailureInvalidCredentials() {
        // GIVEN
        viewModel.updateEmail("tony.stark@example.com")
        viewModel.updatePassword("password123")
        mockUserRepository.loginSuccess = false
        mockUserRepository.loginError = LoginError.invalidCredentials

        let loginExpectation = expectation(description: "Login should fail with invalid credentials")

        // WHEN
        viewModel.login()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // THEN
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertFalse(self.viewModel.isLoginSuccessful)
            XCTAssertEqual(self.viewModel.loginError, .invalidCredentials)
            loginExpectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }
}
