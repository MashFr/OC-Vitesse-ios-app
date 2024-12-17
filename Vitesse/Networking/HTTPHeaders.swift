//
//  HTTPHeaders.swift
//  Vitesse
//
//  Created by Tony Stark on 09/12/2024.
//
import Foundation

class HTTPHeaders {
    var value: [String: String] = [:]

    enum ContentType: String {
        case json = "application/json"
        case xml = "application/xml"
        case formUrlEncoded = "application/x-www-form-urlencoded"
        case plainText = "text/plain"

        var header: [String: String] {
            ["Content-Type": self.rawValue]
        }
    }

    enum Accept: String {
        case json = "application/json"
        case xml = "application/xml"
        case html = "text/html"

        var header: [String: String] {
            ["Accept": self.rawValue]
        }
    }

    /// Initializer where all values can be `nil`.
    init(contentType: ContentType? = nil, accept: Accept? = nil) {
        if let contentType = contentType {
            self.value.merge(contentType.header) { _, new in new }
        }
        if let accept = accept {
            self.value.merge(accept.header) { _, new in new }
        }
    }

    /// Basic initializer for JSON headers.
    convenience init(forJSON: Bool, authToken: String? = nil) {
        self.init(contentType: .json, accept: .json)
        if let authToken {
            addAuthorization(token: authToken)
        }
    }

    func addAuthorization(token: String) {
        value["Authorization"] = "Bearer \(token)"
    }

    /// Adds headers to a given URLRequest and returns the modified request
    func addToRequest(request: URLRequest) -> URLRequest {
        var modifiedRequest = request
        value.forEach { key, value in
            modifiedRequest.setValue(value, forHTTPHeaderField: key)
        }
        return modifiedRequest
    }
}
