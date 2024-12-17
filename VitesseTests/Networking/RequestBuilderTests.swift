//
//  RequestBuilderTests.swift
//  Vitesse
//
//  Created by Tony Stark on 06/12/2024.
//
@testable import Vitesse
import XCTest

final class RequestBuilderTests: XCTestCase {

    func testBuildRequestWithValidURL() {
        // Given
        let endpoint = APIEndpoint.getCandidates
        let method = HTTPMethod.GET

        // When
        do {
            let request = try RequestBuilder.buildRequest(endpoint: endpoint, method: method)

            // Then
            XCTAssertEqual(request.url?.absoluteString, endpoint.url?.absoluteString)
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNil(request.httpBody)
            XCTAssertTrue(request.allHTTPHeaderFields?.isEmpty ?? true)
        } catch {
            XCTFail("RequestBuilder should not throw an error for a valid URL")
        }
    }

    func testBuildRequestWithInvalidURL() {
        // Given
        let endpoint = APIEndpoint.custom(path: " ")
        let method = HTTPMethod.GET

        // When
        XCTAssertThrowsError(try RequestBuilder.buildRequest(endpoint: endpoint, method: method)) { error in
            // Then
            if let apiError = error as? APIError, case .invalidURL = apiError {
                XCTAssertTrue(true, "Error is of type APIError.invalidURL")
            } else {
                XCTFail("Expected APIError.invalidURL but got \(error)")
            }
        }
    }

    func testBuildRequestWithHeaders() {
        // Given
        let endpoint = APIEndpoint.authenticate
        let method = HTTPMethod.POST
        let headers = HTTPHeaders(contentType: .json, accept: .json)

        // When
        do {
            let request = try RequestBuilder.buildRequest(endpoint: endpoint, method: method, headers: headers)

            // Then
            XCTAssertEqual(request.url?.absoluteString, endpoint.url?.absoluteString)
            XCTAssertEqual(request.httpMethod, "POST")

            XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/json")
            XCTAssertEqual(request.allHTTPHeaderFields?["Accept"], "application/json")
        } catch {
            XCTFail("RequestBuilder should not throw an error for valid headers")
        }
    }

    func testBuildRequestWithBody() {
        // Given
        let endpoint = APIEndpoint.register
        let method = HTTPMethod.POST
        let bodyString = "{\"username\": \"test\", \"password\": \"1234\"}"
        let body = Data(bodyString.utf8) // Non-optional Data conversion

        // When
        do {
            let request = try RequestBuilder.buildRequest(endpoint: endpoint, method: method, body: body)

            // Then
            XCTAssertEqual(request.url?.absoluteString, endpoint.url?.absoluteString)
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.httpBody, body)
        } catch {
            XCTFail("RequestBuilder should not throw an error for valid body data")
        }
    }

    func testBuildRequestWithHeadersAndBody() {
        // Given
        let endpoint = APIEndpoint.createCandidate
        let method = HTTPMethod.POST
        let headers = HTTPHeaders(forJSON: true)
        let bodyString = "{\"name\": \"John Doe\", \"email\": \"johndoe@example.com\"}"
        let body = Data(bodyString.utf8) // Non-optional Data conversion

        // When
        do {
            let request = try RequestBuilder.buildRequest(
                endpoint: endpoint,
                method: method,
                body: body,
                headers: headers
            )

            // Then
            XCTAssertEqual(request.url?.absoluteString, endpoint.url?.absoluteString)
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.httpBody, body)
            XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/json")
            XCTAssertEqual(request.allHTTPHeaderFields?["Accept"], "application/json")
        } catch {
            XCTFail("RequestBuilder should not throw an error for valid headers and body")
        }
    }
}
