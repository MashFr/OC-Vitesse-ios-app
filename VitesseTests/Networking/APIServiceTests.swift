//
//  APIServiceTests.swift
//  VitesseTests
//
//  Created by Tony Stark on 05/12/2024.
//

import XCTest
@testable import Vitesse

// MARK: - Helper

struct TestModel: Codable, Equatable {
    let id: Int
    let name: String
}

// MARK: - Test

class APIServiceTests: XCTestCase {
    var apiService: APIService!
    var mockSession: URLSession!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: configuration)
        apiService = APIService(session: mockSession)
    }

    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        apiService = nil
        mockSession = nil
        super.tearDown()
    }

    // MARK: Test FetchDecodable

    func testFetchDecodable_Success() {
        // Given
        let expectedData = TestModel(id: 1, name: "Test")
        do {
            let responseData = try JSONEncoder().encode(expectedData)

            let expectedEndpoint = APIEndpoint.checkAPI
            let expectedResponse = HTTPURLResponse(
                url: expectedEndpoint.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            MockURLProtocol.requestHandler = { request in
                XCTAssertEqual(request.url, expectedEndpoint.url)
                XCTAssertEqual(request.httpMethod, HTTPMethod.GET.rawValue)
                return MockResponse(response: expectedResponse, data: responseData, error: nil)
            }
        } catch {
            XCTFail("Failed to encode expectedData: \(error)")
        }

        let expectation = self.expectation(description: "FetchDecodable completes")

        // When
        apiService.fetchDecodable(
            endpoint: APIEndpoint.checkAPI,
            method: .GET
        ) { (result: Result<TestModel, Error>) in
            // Then
            switch result {
            case .success(let model):
                XCTAssertEqual(model, expectedData)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchDecodable_Failure_TaskError() {
        // Given
        let expectedEndpoint = APIEndpoint.checkAPI

        let nsError = NSError(domain: "TestDomain", code: 1234, userInfo: [NSLocalizedDescriptionKey: "Mocked error"])

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, expectedEndpoint.url)
            XCTAssertEqual(request.httpMethod, HTTPMethod.GET.rawValue)
            return MockResponse(response: nil, data: nil, error: nsError)
        }

        let expectation = self.expectation(description: "FetchDecodable completes")

        // When
        apiService.fetchDecodable(endpoint: expectedEndpoint, method: .GET) { (result: Result<TestModel, Error>) in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                // Vérification que l'erreur est bien un NSError et correspond à ce qu'on a simulé
                XCTAssertEqual((error as NSError).domain, nsError.domain)
                XCTAssertEqual((error as NSError).code, nsError.code)
                XCTAssertEqual((error as NSError).localizedDescription, nsError.localizedDescription)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchDecodable_Failure_InvalidResponse() {
        // Given
        let expectedEndpoint = APIEndpoint.checkAPI

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, expectedEndpoint.url)
            XCTAssertEqual(request.httpMethod, HTTPMethod.GET.rawValue)
            return MockResponse(response: nil, data: nil, error: nil) // Pas de réponse HTTP
        }

        let expectation = self.expectation(description: "FetchDecodable fails due to invalid response")

        // When
        apiService.fetchDecodable(endpoint: expectedEndpoint, method: .GET) { (result: Result<TestModel, Error>) in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                if let apiError = error as? APIError, case .invalidResponse = apiError {
                    XCTAssertTrue(true, "Error is of type APIError.invalidResponse")
                } else {
                    XCTFail("Expected APIError.invalidResponse but got \(error)")
                }
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchDecodable_Failure_HTTPError() {
        // Given
        let expectedEndpoint = APIEndpoint.checkAPI
        let expectedStatusCode = 404

        let expectedResponse = HTTPURLResponse(
            url: expectedEndpoint.url!,
            statusCode: expectedStatusCode,
            httpVersion: nil,
            headerFields: nil
        )!

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, expectedEndpoint.url)
            XCTAssertEqual(request.httpMethod, HTTPMethod.GET.rawValue)
            return MockResponse(response: expectedResponse, data: nil, error: nil)
        }

        let expectation = self.expectation(description: "FetchDecodable fails due to HTTP error")

        // When
        apiService.fetchDecodable(endpoint: expectedEndpoint, method: .GET) { (result: Result<TestModel, Error>) in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                // Vérifier le type d'erreur et son contenu
                if let apiError = error as? APIError, case let .httpError(statusCode) = apiError {
                    XCTAssertEqual(statusCode, expectedStatusCode)
                } else {
                    XCTFail("Expected APIError.httpError but got \(error)")
                }
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchDecodable_Failure_NoData() {
        // Given
        let expectedEndpoint = APIEndpoint.checkAPI

        let expectedResponse = HTTPURLResponse(
            url: expectedEndpoint.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, expectedEndpoint.url)
            XCTAssertEqual(request.httpMethod, HTTPMethod.GET.rawValue)
            return MockResponse(response: expectedResponse, data: Data(), error: nil) // Pas de données
        }

        let expectation = self.expectation(description: "FetchDecodable fails due to no data")

        // When
        apiService.fetchDecodable(endpoint: expectedEndpoint, method: .GET) { (result: Result<TestModel, Error>) in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                // Vérifier le type d'erreur
                if let apiError = error as? APIError, case .noData = apiError {
                    XCTAssertTrue(true, "Error is of type APIError.noData")
                } else {
                    XCTFail("Expected APIError.noData but got \(error)")
                }
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchDecodable_Failure_DecodingError() {
        // Given
        let expectedEndpoint = APIEndpoint.checkAPI

        // On fournit des données invalides pour le modèle `TestModel`
        let invalidJSONData = Data("""
        { "invalidKey": "invalidValue" }
        """.utf8)

        let expectedResponse = HTTPURLResponse(
            url: expectedEndpoint.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, expectedEndpoint.url)
            XCTAssertEqual(request.httpMethod, HTTPMethod.GET.rawValue)
            return MockResponse(response: expectedResponse, data: invalidJSONData, error: nil)
        }

        let expectation = self.expectation(description: "FetchDecodable fails due to JSON decoding error")

        // When
        apiService.fetchDecodable(endpoint: expectedEndpoint, method: .GET) { (result: Result<TestModel, Error>) in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                // Vérification que l'erreur est bien une erreur de décodage JSON
                guard let decodingError = error as? DecodingError else {
                    XCTFail("Expected DecodingError but got \(error)")
                    expectation.fulfill()
                    return
                }

                // Vérification supplémentaire sur le type d'erreur de décodage
                switch decodingError {
                case .typeMismatch, .valueNotFound, .keyNotFound, .dataCorrupted:
                    XCTAssertTrue(true, "Error is a valid DecodingError: \(decodingError)")
                default:
                    XCTFail("Unexpected DecodingError type: \(decodingError)")
                }
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    // MARK: Test Fetch

    func testFetch_Success() {
        // Given
        let expectedEndpoint = APIEndpoint.checkAPI
        let expectedResponse = HTTPURLResponse(
            url: expectedEndpoint.url!,
            statusCode: 204,
            httpVersion: nil,
            headerFields: nil
        )!

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, expectedEndpoint.url)
            XCTAssertEqual(request.httpMethod, HTTPMethod.POST.rawValue)
            return MockResponse(response: expectedResponse, data: nil, error: nil)
        }

        let expectation = self.expectation(description: "Fetch completes")

        // When
        apiService.fetch(endpoint: expectedEndpoint, method: .POST) { result in
            // Then
            switch result {
            case .success:
                XCTAssertTrue(true) // Success as expected
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetch_Failure_TaskError() {
        // Given
        let expectedEndpoint = APIEndpoint.checkAPI

        let nsError = NSError(domain: "TestDomain", code: 1234, userInfo: [NSLocalizedDescriptionKey: "Mocked error"])

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, expectedEndpoint.url)
            XCTAssertEqual(request.httpMethod, HTTPMethod.GET.rawValue)
            return MockResponse(response: nil, data: nil, error: nsError)
        }

        let expectation = self.expectation(description: "Fetch fails due to invalid URL")

        // When
        apiService.fetch(endpoint: expectedEndpoint, method: .GET) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                // Vérification que l'erreur est bien un NSError et correspond à ce qu'on a simulé
                XCTAssertEqual((error as NSError).domain, nsError.domain)
                XCTAssertEqual((error as NSError).code, nsError.code)
                XCTAssertEqual((error as NSError).localizedDescription, nsError.localizedDescription)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetch_Failure_InvalidResponse() {
        // Given
        let expectedEndpoint = APIEndpoint.checkAPI

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, expectedEndpoint.url)
            XCTAssertEqual(request.httpMethod, HTTPMethod.POST.rawValue)
            return MockResponse(response: nil, data: nil, error: nil) // Pas de réponse HTTP
        }

        let expectation = self.expectation(description: "Fetch fails due to invalid response")

        // When
        apiService.fetch(endpoint: expectedEndpoint, method: .POST) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                // Vérifier le type d'erreur
                if let apiError = error as? APIError, case .invalidResponse = apiError {
                    XCTAssertTrue(true, "Error is of type APIError.invalidResponse")
                } else {
                    XCTFail("Expected APIError.invalidResponse but got \(error)")
                }
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetch_Failure_HTTPError() {
        // Given
        let expectedEndpoint = APIEndpoint.checkAPI
        let expectedStatusCode = 500

        let expectedResponse = HTTPURLResponse(
            url: expectedEndpoint.url!,
            statusCode: expectedStatusCode,
            httpVersion: nil,
            headerFields: nil
        )!

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, expectedEndpoint.url)
            XCTAssertEqual(request.httpMethod, HTTPMethod.POST.rawValue)
            return MockResponse(response: expectedResponse, data: nil, error: nil)
        }

        let expectation = self.expectation(description: "Fetch fails due to HTTP error")

        // When
        apiService.fetch(endpoint: expectedEndpoint, method: .POST) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                // Vérifier le type d'erreur et son contenu
                if let apiError = error as? APIError, case let .httpError(statusCode) = apiError {
                    XCTAssertEqual(statusCode, expectedStatusCode)
                } else {
                    XCTFail("Expected APIError.httpError but got \(error)")
                }
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}
