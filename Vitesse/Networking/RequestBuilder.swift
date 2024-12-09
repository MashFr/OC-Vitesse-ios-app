//
//  RequestBuilder.swift
//  Vitesse
//
//  Created by Tony Stark on 03/12/2024.
//
import Foundation

/// A utility struct responsible for building network requests.
struct RequestBuilder {

    /// Builds a `URLRequest` based on the provided parameters, including the endpoint, HTTP method, body, and headers.
    static func buildRequest(
        endpoint: APIEndpoint,
        method: HTTPMethod,
        body: Data? = nil,
        headers: HTTPHeaders? = nil
    ) throws(APIError) -> URLRequest {
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let headers = headers {
            request = headers.addToRequest(request: request)
        }

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
