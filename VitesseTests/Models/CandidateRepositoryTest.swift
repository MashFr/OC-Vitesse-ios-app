//
//  CandidateRepositoryTest.swift
//  VitesseTests
//
//  Created by Tony Stark on 05/12/2024.
//
import XCTest
@testable import Vitesse

class CandidateRepositoryTests: XCTestCase {
    private var candidateRepository: CandidateRepository!
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
        candidateRepository = CandidateRepository(apiService: apiService, keychainService: keychainService)

        // Mock the keychain token retrieval
        try? keychainService.save("mock_auth_token", forKey: "auth_token")
    }

    override func tearDown() {
        candidateRepository = nil
        apiService = nil
        keychainService = nil
        MockURLProtocol.requestHandler = nil

        super.tearDown()
    }

    // MARK: - Success Cases

    func testFetchCandidatesSuccess() {
        // GIVEN a successful API response with mock candidate data
        let mockCandidatesDTO = [
            CandidateDTO(
                id: UUID(),
                firstName: "John",
                lastName: "Doe",
                email: "john@example.com",
                phone: nil,
                linkedinURL: nil,
                note: nil,
                isFavorite: false
            )
        ]
        let mockData = try? JSONEncoder().encode(mockCandidatesDTO)
        guard let encodedData = mockData else {
            XCTFail("Failed to encode mock candidates")
            return
        }
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        MockURLProtocol.requestHandler = { _ in
            return MockResponse(response: mockResponse, data: encodedData, error: nil)
        }

        let expectation = self.expectation(description: "FetchCandidates should succeed")

        // WHEN fetchCandidates is called
        candidateRepository.fetchCandidates { result in
            // THEN the repository should return the correct data
            switch result {
            case .success(let candidates):
                // Assert
                XCTAssertEqual(candidates.count, 1)
                XCTAssertEqual(candidates.first?.firstName, "John")
                XCTAssertEqual(candidates.first?.lastName, "Doe")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, got failure with error: \(error)")
            }
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testFetchCandidateByIdSuccess() {
        // GIVEN a successful API response for a specific candidate
        let candidateId = UUID()
        let mockCandidateDTO = CandidateDTO(
            id: candidateId,
            firstName: "John",
            lastName: "Doe",
            email: "john@example.com",
            phone: nil,
            linkedinURL: nil,
            note: nil,
            isFavorite: false
        )
        let mockData = try? JSONEncoder().encode(mockCandidateDTO)
        guard let encodedData = mockData else {
            XCTFail("Failed to encode mock candidate")
            return
        }
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.path, "/candidate/\(candidateId.uuidString)")
            return MockResponse(response: mockResponse, data: encodedData, error: nil)
        }

        let expectation = self.expectation(description: "FetchCandidateById should succeed")

        // WHEN fetchCandidateById is called
        candidateRepository.fetchCandidateById(candidateId: candidateId) { result in
            switch result {
            case .success(let candidate):
                // THEN the repository should return the correct candidate data
                XCTAssertEqual(candidate.id, candidateId)
                XCTAssertEqual(candidate.firstName, "John")
                XCTAssertEqual(candidate.lastName, "Doe")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, got failure with error: \(error)")
            }
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testCreateCandidateSuccess() {
        // GIVEN a successful API response for a candidate creation
        let mockCandidate = Candidate(
            id: UUID(),
            firstName: "John",
            lastName: "Doe",
            email: "john@example.com",
            phone: nil,
            linkedinURL: nil,
            note: nil,
            isFavorite: false
        )
        let mockCandidateDTO = mockCandidate.toDTO()
        let mockData = try? JSONEncoder().encode(mockCandidateDTO)
        guard let encodedData = mockData else {
            XCTFail("Failed to encode mock candidate")
            return
        }
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 201,
            httpVersion: nil,
            headerFields: nil
        )

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            return MockResponse(response: mockResponse, data: encodedData, error: nil)
        }

        let expectation = self.expectation(description: "CreateCandidate should succeed")

        // WHEN createCandidate is called
        candidateRepository.createCandidate(candidate: mockCandidate) { result in
            switch result {
            case .success(let createdCandidate):
                // THEN the repository should return the correct new candidate data
                XCTAssertEqual(createdCandidate.firstName, "John")
                XCTAssertEqual(createdCandidate.lastName, "Doe")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, got failure with error: \(error)")
            }
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testUpdateCandidateSuccess() {
        // GIVEN a successful API response for a candidate update
        let mockCandidate = Candidate(
            id: UUID(),
            firstName: "Jane",
            lastName: "Doe",
            email: "jane@example.com",
            phone: nil,
            linkedinURL: nil,
            note: nil,
            isFavorite: false
        )
        let mockCandidateDTO = mockCandidate.toDTO()
        let mockData = try? JSONEncoder().encode(mockCandidateDTO)
        guard let encodedData = mockData else {
            XCTFail("Failed to encode mock candidate")
            return
        }
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "PUT")
            return MockResponse(response: mockResponse, data: encodedData, error: nil)
        }

        let expectation = self.expectation(description: "UpdateCandidate should succeed")

        // WHEN updateCandidate is called
        candidateRepository.updateCandidate(candidate: mockCandidate) { result in
            // THEN the repository should return the correct new candidate data
            switch result {
            case .success(let updatedCandidate):
                XCTAssertEqual(updatedCandidate.firstName, "Jane")
                XCTAssertEqual(updatedCandidate.lastName, "Doe")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, got failure with error: \(error)")
            }
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testDeleteCandidateSuccess() {
        // GIVEN a successful API response for a candidate deletion
        let candidateId = UUID()
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 204,
            httpVersion: nil,
            headerFields: nil
        )

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "DELETE")
            XCTAssertEqual(request.url?.path, "/candidate/\(candidateId.uuidString)")
            return MockResponse(response: mockResponse, data: nil, error: nil)
        }

        let expectation = self.expectation(description: "DeleteCandidate should succeed")

        // WHEN deleteCandidate is called
        candidateRepository.deleteCandidate(candidateId: candidateId) { result in
            // THEN the repository should return succes with 204 and nothing in data
            switch result {
            case .success(let data):
                XCTAssertTrue(data == nil || data?.isEmpty == true, "Expected data to be nil or empty for 204 response")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, got failure with error: \(error)")
            }
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    // MARK: - Failure Scenarios

    func testFetchCandidatesFailureDueToTokenError() {
        // GIVEN the auth token is missing
        try? keychainService.delete(forKey: "auth_token")

        let expectation = self.expectation(description: "FetchCandidates should fail due to missing auth token")

        // WHEN fetchCandidates is called
        candidateRepository.fetchCandidates { result in
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

    func testCreateCandidateFailureDueToEncodingError() {
        // GIVEN a candidate with invalid data that causes an encoding error
        let mockCandidate = Candidate(
            id: UUID(),
            firstName: "John",
            lastName: "Doe",
            email: String(repeating: "a", count: 10_000), // Intentionally oversized to cause encoding error
            phone: nil,
            linkedinURL: nil,
            note: nil,
            isFavorite: false
        )

        let expectation = self.expectation(description: "createCandidate should fail due to encoding error")

        // WHEN createCandidate is called
        candidateRepository.createCandidate(candidate: mockCandidate) { result in
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
