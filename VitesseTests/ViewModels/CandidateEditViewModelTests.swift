//
//  CandidateEditViewModelTests.swift
//  Vitesse
//
//  Created by Tony Stark on 16/12/2024.
//
@testable import Vitesse
import XCTest

final class CandidateEditViewModelTests: XCTestCase {

    private var viewModel: CandidateEditViewModel!
    private var mockRepository: MockCandidateRepository!
    private var testCandidate: Candidate!

    override func setUp() {
        super.setUp()
        mockRepository = MockCandidateRepository()
        testCandidate = Candidate(
            id: UUID(),
            firstName: "John",
            lastName: "Doe",
            email: "john.doe@example.com",
            phone: "+123456789",
            linkedinURL: URL(string: "https://linkedin.com/in/johndoe"),
            note: nil,
            isFavorite: false
        )
        viewModel = CandidateEditViewModel(candidateRepository: mockRepository, candidate: testCandidate)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        testCandidate = nil
        super.tearDown()
    }

    // MARK: - Tests for Field Updates

    func testUpdateEmail() {
        // GIVEN
        let newEmail = "jane.doe@example.com"

        // WHEN
        viewModel.updateEmail(newEmail)

        // THEN
        XCTAssertEqual(viewModel.candidate.email, newEmail)
    }

    func testUpdatePhone() {
        // GIVEN
        let newPhone = "+987654321"

        // WHEN
        viewModel.updatePhone(newPhone)

        // THEN
        XCTAssertEqual(viewModel.candidate.phone, newPhone)
    }

    func testUpdateLinkedInURL() {
        // GIVEN
        let newLinkedInURL = "https://linkedin.com/in/janedoe"

        // WHEN
        viewModel.updateLinkedInURL(newLinkedInURL)

        // THEN
        XCTAssertEqual(viewModel.candidate.linkedinURL?.absoluteString, newLinkedInURL)
    }

    func testUpdateNote() {
        // GIVEN
        let newNote = "This is a new note."

        // WHEN
        viewModel.updateNote(newNote)

        // THEN
        XCTAssertEqual(viewModel.candidate.note, newNote)
    }

    // MARK: - Tests for Field Validation

    func testValidateEmailWithValidEmail() {
        // GIVEN
        viewModel.updateEmail("valid.email@example.com")

        // WHEN
        viewModel.saveCandidate()

        // THEN
        XCTAssertNil(viewModel.emailError)
    }

    func testValidateEmailWithInvalidEmail() {
        // GIVEN
        viewModel.updateEmail("invalid-email")

        // WHEN
        viewModel.saveCandidate()

        // THEN
        XCTAssertEqual(viewModel.emailError, .invalidEmail)
    }

    func testValidateEmailWithEmptyEmail() {
        // GIVEN
        viewModel.updateEmail("")

        // WHEN
        viewModel.saveCandidate()

        // THEN
        XCTAssertEqual(viewModel.emailError, .emptyField(fieldName: "Email"))
    }

    func testValidatePhoneWithValidPhone() {
        // GIVEN
        viewModel.updatePhone("+1234567890")

        // WHEN
        viewModel.saveCandidate()

        // THEN
        XCTAssertNil(viewModel.phoneError)
    }

    func testValidatePhoneWithInvalidPhone() {
        // GIVEN
        viewModel.updatePhone("123-abc")

        // WHEN
        viewModel.saveCandidate()

        // THEN
        XCTAssertEqual(viewModel.phoneError, .invalidPhone)
    }

    func testValidateLinkedInURLWithValidURL() {
        // GIVEN
        viewModel.updateLinkedInURL("https://linkedin.com/in/validprofile")

        // WHEN
        viewModel.saveCandidate()

        // THEN
        XCTAssertNil(viewModel.linkedInURLError)
    }

    func testValidateLinkedInURLWithInvalidURL() {
        // GIVEN
        viewModel.updateLinkedInURL("invalid-url")

        // WHEN
        viewModel.saveCandidate()

        // THEN
        XCTAssertEqual(viewModel.linkedInURLError, .invalidURL)
    }

    // MARK: - Tests for Save Candidate (Update)

    func testSaveCandidateSuccess() {
        // GIVEN
        mockRepository.updateCandidateResult = .success(testCandidate)

        let expectation = self.expectation(description: "Save Candidate Success")

        // WHEN
        viewModel.saveCandidate()

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.viewModel.isSaving)
            XCTAssertTrue(self.viewModel.showSuccessAlert)
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testSaveCandidateFailure() {
        // GIVEN
        let error = NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to save candidate"])
        mockRepository.updateCandidateResult = .failure(error)

        let expectation = self.expectation(description: "Save Candidate Failure")

        // WHEN
        viewModel.saveCandidate()

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.viewModel.isSaving)
            XCTAssertTrue(self.viewModel.showErrorAlert)
            XCTAssertEqual(self.viewModel.errorMessage, "Failed to save candidate")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
