//
//  CandidateListViewModelTests.swift
//  Vitesse
//
//  Created by Tony Stark on 16/12/2024.
//
import XCTest
@testable import Vitesse

final class CandidateListViewModelTests: XCTestCase {

    private var viewModel: CandidateListViewModel!
    private var mockRepository: MockCandidateRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockCandidateRepository()
        viewModel = CandidateListViewModel(repository: mockRepository)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Fetch Candidates

    func testFetchCandidatesSuccess() {
        // GIVEN
        let mockCandidates = [
            Candidate(
                id: UUID(),
                firstName: "Tony",
                lastName: "Stark",
                email: "tony@starkindustries.com",
                isFavorite: false
            ),
            Candidate(id: UUID(), firstName: "Bruce", lastName: "Banner", email: "bruce@science.com", isFavorite: true)
        ]
        mockRepository.fetchCandidatesResult = .success(mockCandidates)

        let expectation = self.expectation(description: "Fetch Candidates Success")

        // WHEN
        viewModel.fetchCandidates()

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.filteredCandidates.count, mockCandidates.count)
            XCTAssertEqual(self.viewModel.filteredCandidates.first?.firstName, "Tony")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testFetchCandidatesFailure() {
        // GIVEN
        let mockError = NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network Error"])
        mockRepository.fetchCandidatesResult = .failure(mockError)

        // Create expectation
        let expectation = self.expectation(description: "Fetch Candidates Failure")

        // WHEN
        viewModel.fetchCandidates()

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.viewModel.showErrorAlert)
            XCTAssertEqual(self.viewModel.errorAlertMsg, "Network Error")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    // MARK: - Filter Candidates

    func testFilterCandidatesByFavorites() {
        // GIVEN
        let mockCandidates = [
            Candidate(
                id: UUID(),
                firstName: "Tony",
                lastName: "Stark",
                email: "tony@starkindustries.com",
                isFavorite: false
            ),
            Candidate(id: UUID(), firstName: "Bruce", lastName: "Banner", email: "bruce@science.com", isFavorite: true)
        ]
        mockRepository.fetchCandidatesResult = .success(mockCandidates)
        viewModel.fetchCandidates()

        let expectation = self.expectation(description: "Filter Candidates by Favorites")

        // WHEN
        viewModel.toggleFavoritesFilter()

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.viewModel.showFavoritesOnly)
            XCTAssertEqual(self.viewModel.filteredCandidates.count, 1)
            XCTAssertEqual(self.viewModel.filteredCandidates.first?.firstName, "Bruce")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testFilterCandidatesBySearchText() {
        // GIVEN
        let mockCandidates = [
            Candidate(
                id: UUID(),
                firstName: "Tony",
                lastName: "Stark",
                email: "tony@starkindustries.com",
                isFavorite: false
            ),
            Candidate(id: UUID(), firstName: "Bruce", lastName: "Banner", email: "bruce@science.com", isFavorite: true)
        ]
        mockRepository.fetchCandidatesResult = .success(mockCandidates)
        viewModel.fetchCandidates()

        let expectation = self.expectation(description: "Filter Candidates by Search Text")

        // WHEN
        viewModel.updateSearchText("bruce")

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.filteredCandidates.count, 1)
            XCTAssertEqual(self.viewModel.filteredCandidates.first?.firstName, "Bruce")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    // MARK: - Delete Candidates

    func testDeleteSelectedCandidatesSuccess() {
        // GIVEN
        let candidate1 = Candidate(
            id: UUID(),
            firstName: "Tony",
            lastName: "Stark",
            email: "bruce@science.com",
            isFavorite: false)
        let candidate2 = Candidate(
            id: UUID(),
            firstName: "Bruce",
            lastName: "Banner",
            email: "bruce@science.com",
            isFavorite: true
        )
        let mockCandidates = [candidate1, candidate2]
        mockRepository.fetchCandidatesResult = .success(mockCandidates)
        viewModel.fetchCandidates()
        viewModel.updateSelection([candidate1.id])

        mockRepository.deleteCandidateResult = .success(nil)

        // WHEN
        viewModel.deleteSelectedCandidates()

        mockRepository.fetchCandidatesResult = .success([candidate2])

        let expectation = self.expectation(description: "Delete Selected Candidates Success")

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.candidates.count, 1)
            XCTAssertEqual(self.viewModel.candidates.first?.firstName, "Bruce")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testDeleteSelectedCandidatesFailure() {
        // GIVEN
        let candidate1 = Candidate(
            id: UUID(),
            firstName: "Tony",
            lastName: "Stark",
            email: "bruce@science.com",
            isFavorite: false
        )
        let mockCandidates = [candidate1]
        mockRepository.fetchCandidatesResult = .success(mockCandidates)
        viewModel.fetchCandidates()
        viewModel.updateSelection([candidate1.id])

        let mockError = NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Deletion Failed"])
        mockRepository.deleteCandidateResult = .failure(mockError)

        let expectation = self.expectation(description: "Delete Selected Candidates Failure")

        // WHEN
        viewModel.deleteSelectedCandidates()

        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.viewModel.showErrorAlert)
            XCTAssertEqual(self.viewModel.errorAlertMsg, "1 suppression(s) ont échoué. Veuillez réessayer.")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
