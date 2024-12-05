//
//  RequestBuilder.swift
//  Vitesse
//
//  Created by Tony Stark on 03/12/2024.
//
import Foundation

struct RequestBuilder {

    static func buildRequest(
        endpoint: APIEndpoint,
        method: HTTPMethod,
        body: Data? = nil,
        headers: [String: String]? = nil,
        defaultHeaders: [String: String] = ["Content-Type": "application/json"]
    ) throws(APIError) -> URLRequest {
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        var allHeaders = defaultHeaders
        if let additionalHeaders = headers {
            for (key, value) in additionalHeaders {
                allHeaders[key] = value
            }
        }
        allHeaders.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        if let body = body {
            request.httpBody = body
        }

        return request
    }
}

// MARK: helper
//    private mutating func encodeParametersInURL(
//        _ parameters: [String: Any],
//        components: URLComponents
//    ) {
//        var components = components
//        components.queryItems = parameters
//            .map { ($0, "\($1)") }
//            .map { URLQueryItem(name: $0, value: $1) }
//        url = components.url
//    }
//
//    private mutating func encodeParametersInBody(
//        _ parameters: [String: Any]
//    ) throws {
//        setValue("application/json", forHTTPHeaderField: "Content-Type")
//        httpBody = try JSONSerialization.data(
//            withJSONObject: parameters,
//            options: .prettyPrinted
//        )
//    }
//
