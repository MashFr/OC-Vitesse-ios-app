//
//  RegisterViewModelTests.swift
//  Vitesse
//
//  Created by Tony Stark on 16/12/2024.
//
import XCTest
@testable import Vitesse

final class RegisterViewModelTests: XCTestCase {

    private var viewModel: RegisterViewModel!
    private var mockAuthRepository: MockAuthRepository!

    override func setUp() {
        super.setUp()
        mockAuthRepository = MockAuthRepository()
        viewModel = RegisterViewModel(authRepository: mockAuthRepository)
    }

    override func tearDown() {
        viewModel = nil
        mockAuthRepository = nil
        super.tearDown()
    }

    // MARK: - Fields update

    func testUpdateFirstName() {
        // WHEN
        viewModel.updateFirstName("Tony")

        // THEN
        XCTAssertEqual(viewModel.firstName, "Tony")
    }

    func testUpdateLastName() {
        // WHEN
        viewModel.updateLastName("Stark")

        // THEN
        XCTAssertEqual(viewModel.lastName, "Stark")
    }

    func testUpdateEmailAddress() {
        // WHEN
        viewModel.updateEmailAddress("tony.stark@example.com")

        // THEN
        XCTAssertEqual(viewModel.emailAddress, "tony.stark@example.com")
    }

    func testUpdatePassword() {
        // WHEN
        viewModel.updatePassword("password123")

        // THEN
        XCTAssertEqual(viewModel.password, "password123")
    }

    func testUpdateConfirmPassword() {
        // WHEN
        viewModel.updateConfirmPassword("password123")

        // THEN
        XCTAssertEqual(viewModel.confirmPassword, "password123")
    }

    func testUpdateShowErrorAlert() {
        // GIVEN
        viewModel.updateShowErrorAlert(true)

        // THEN
        XCTAssertTrue(viewModel.showErrorAlert)
        XCTAssertNil(viewModel.errorMessage)

        // WHEN
        viewModel.updateShowErrorAlert(false)

        // THEN
        XCTAssertFalse(viewModel.showErrorAlert)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testUpdateShowSuccessAlert() {
        // GIVEN
        viewModel.updateShowSuccessAlert(true)

        // THEN
        XCTAssertTrue(viewModel.showSuccessAlert)

        // WHEN
        viewModel.updateShowSuccessAlert(false)

        // THEN
        XCTAssertFalse(viewModel.showSuccessAlert)
    }

    // MARK: - Register Tests

    func testRegisterWithValidFields() {
        // GIVEN
        viewModel.updateFirstName("Tony")
        viewModel.updateLastName("Stark")
        viewModel.updateEmailAddress("tony.stark@example.com")
        viewModel.updatePassword("password123")
        viewModel.updateConfirmPassword("password123")

        let registerExpectation = expectation(description: "Register should complete successfully")
        mockAuthRepository.registerSuccess = true

        // WHEN
        viewModel.register()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // THEN
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertTrue(self.viewModel.showSuccessAlert)
            XCTAssertNil(self.viewModel.errorMessage)
            registerExpectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testRegisterWithEmptyFirstName() {
        // GIVEN
        viewModel.updateFirstName("") // First name is empty
        viewModel.updateLastName("Stark")
        viewModel.updateEmailAddress("tony.stark@example.com")
        viewModel.updatePassword("password123")
        viewModel.updateConfirmPassword("password123")

        // WHEN
        viewModel.register()

        // THEN
        XCTAssertNotNil(viewModel.firstNameError)
        XCTAssertEqual(viewModel.firstNameError, .emptyField(fieldName: "First Name"))
        XCTAssertFalse(viewModel.showSuccessAlert)
    }

    func testRegisterWithInvalidEmail() {
        // GIVEN
        viewModel.updateFirstName("Tony")
        viewModel.updateLastName("Stark")
        viewModel.updateEmailAddress("invalid-email")
        viewModel.updatePassword("password123")
        viewModel.updateConfirmPassword("password123")

        // WHEN
        viewModel.register()

        // THEN
        XCTAssertNotNil(viewModel.emailError)
        XCTAssertEqual(viewModel.emailError, .invalidEmail)
        XCTAssertFalse(viewModel.showSuccessAlert)
    }

    func testRegisterWithMismatchedPasswords() {
        // GIVEN
        viewModel.updateFirstName("Tony")
        viewModel.updateLastName("Stark")
        viewModel.updateEmailAddress("tony.stark@example.com")
        viewModel.updatePassword("password123")
        viewModel.updateConfirmPassword("differentPassword") // Mismatched password

        // WHEN
        viewModel.register()

        // THEN
        XCTAssertNotNil(viewModel.confirmPasswordError)
        XCTAssertEqual(viewModel.confirmPasswordError, .passwordsDoNotMatch)
        XCTAssertFalse(viewModel.showSuccessAlert)
    }

    func testRegisterFailureFromRepository() {
        // GIVEN
        viewModel.updateFirstName("Tony")
        viewModel.updateLastName("Stark")
        viewModel.updateEmailAddress("tony.stark@example.com")
        viewModel.updatePassword("password123")
        viewModel.updateConfirmPassword("password123")

        let registerExpectation = expectation(description: "Register should fail with repository error")
        mockAuthRepository.registerSuccess = false
        mockAuthRepository.registerError = NSError(
            domain: "Test",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Registration failed"]
        )

        // WHEN
        viewModel.register()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // THEN
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertTrue(self.viewModel.showErrorAlert)
            XCTAssertEqual(self.viewModel.errorMessage, "Registration failed")
            registerExpectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }
}
