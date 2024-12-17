//
//  CandidateDetailViewModelTests.swift
//  Vitesse
//
//  Created by Tony Stark on 16/12/2024.
//
@testable import Vitesse
import XCTest

final class CandidateDetailViewModelTests: XCTestCase {

    var viewModel: CandidateDetailViewModel!
    var mockRepository: MockCandidateRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockCandidateRepository()
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    func testMarkCandidateAsFavoriteSuccess() {
        // GIVEN
        let candidate = Candidate(
            id: UUID(),
            firstName: "Tony",
            lastName: "Stark",
            email: "tony@starkindustries.com",
            isFavorite: false
        )
        let updatedCandidate = Candidate(
            id: candidate.id,
            firstName: candidate.firstName,
            lastName: candidate.lastName,
            email: candidate.email,
            isFavorite: true
        )

        mockRepository.markCandidateAsFavoriteResult = .success(updatedCandidate)
        viewModel = CandidateDetailViewModel(candidate: candidate, candidateRepository: mockRepository)

        let expectation = self.expectation(description: "Mark Candidate As Favorite Success")

        // WHEN
        viewModel.markCandidateAsFavorite()

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.viewModel.candidate.isFavorite)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testMarkCandidateAsFavoriteFailure() {
        // GIVEN
        let candidate = Candidate(
            id: UUID(),
            firstName: "Tony",
            lastName: "Stark",
            email: "tony@starkindustries.com",
            isFavorite: false
        )
        let error = NSError(
            domain: "Test",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Failed to mark as favorite"]
        )

        mockRepository.markCandidateAsFavoriteResult = .failure(error)
        viewModel = CandidateDetailViewModel(candidate: candidate, candidateRepository: mockRepository)

        let expectation = self.expectation(description: "Mark Candidate As Favorite Failure")

        // WHEN
        viewModel.markCandidateAsFavorite()

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.viewModel.candidate.isFavorite)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testFetchCandidateSuccess() {
        // GIVEN
        let candidate = Candidate(
            id: UUID(),
            firstName: "Bruce",
            lastName: "Wayne",
            email: "bruce@wayneenterprises.com",
            isFavorite: false
        )

        mockRepository.fetchCandidateByIdResult = .success(candidate)
        viewModel = CandidateDetailViewModel(candidate: candidate, candidateRepository: mockRepository)

        let expectation = self.expectation(description: "Fetch Candidate By ID Success")

        // WHEN
        viewModel.fetchCandidate()

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.candidate.id, candidate.id)
            XCTAssertEqual(self.viewModel.candidate.firstName, candidate.firstName)
            XCTAssertEqual(self.viewModel.candidate.lastName, candidate.lastName)
            XCTAssertEqual(self.viewModel.candidate.email, candidate.email)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testFetchCandidateFailure() {
        // GIVEN
        let error = NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch candidate"])

        mockRepository.fetchCandidateByIdResult = .failure(error)
        let candidate = Candidate(
            id: UUID(),
            firstName: "Bruce",
            lastName: "Wayne",
            email: "bruce@wayneenterprises.com",
            isFavorite: false
        )
        viewModel = CandidateDetailViewModel(candidate: candidate, candidateRepository: mockRepository)

        let expectation = self.expectation(description: "Fetch Candidate By ID Failure")

        // WHEN
        viewModel.fetchCandidate()

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.showErrorAlert, true)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
