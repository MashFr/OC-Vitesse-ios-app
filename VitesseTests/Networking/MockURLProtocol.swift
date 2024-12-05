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

class MockURLProtocol: URLProtocol {
    // through this closure that we will define the mocked data that we want the call to return
    static var requestHandler: ((URLRequest) throws -> MockResponse)?

    // we want MockURLProtocol to intercept all the requests made by a URLSession
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
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
            let mockResponse = try handler(request)

            // We have a mock response specified so return it.
            if let response = mockResponse.response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            // We have mocked data specified so return it.
            if let data = mockResponse.data {
                self.client?.urlProtocol(self, didLoad: data)
            }

            // We have a mocked error so return it.
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
