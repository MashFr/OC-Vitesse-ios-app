//
//  MockURLProtocol.swift
//  VitesseTests
//
//  Created by Tony Stark on 05/12/2024.
//
import Foundation
import XCTest
@testable import Vitesse

struct MockResponse {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
}

/// A custom URLProtocol used for mocking network requests in unit tests.
class MockURLProtocol: URLProtocol {
    /// A closure that provides the mocked response for a given request.
    /// This is used to define the mock data that should be returned when a request is made.
    static var requestHandler: ((URLRequest) throws -> MockResponse)?

    // we want MockURLProtocol to intercept all the requests made by a URLSession
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        // Ensure that the request handler is set
        guard let handler = MockURLProtocol.requestHandler else {
            let error = NSError(
                domain: "MockURLProtocol",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Handler not set"]
            )
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        // Mock the response and data from the handler and send it to URLSession
        do {
            // Fetch the mock response using the provided handler
            let mockResponse = try handler(request)

            // If a mock HTTP response is provided, send it to the client
            if let response = mockResponse.response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            // If mock data is provided, load it into the client
            if let data = mockResponse.data {
                self.client?.urlProtocol(self, didLoad: data)
            }

            // If a mock error is provided, send it to the client
            if let error = mockResponse.error {
                self.client?.urlProtocol(self, didFailWithError: error)
            }
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}

}
