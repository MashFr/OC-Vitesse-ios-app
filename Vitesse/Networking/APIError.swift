//
//  APIError.swift
//  Vitesse
//
//  Created by Tony Stark on 27/11/2024.
//
import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case noData
    case decodingError
    case unauthorized

    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .invalidResponse:
            return "Invalid response from the server."
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .noData:
            return "No data received from the server."
        case .decodingError:
            return "Failed to decode the data."
        case .unauthorized:
            return "You are not authorized to perform this action."
        }
    }
}
