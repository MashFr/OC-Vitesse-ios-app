//
//  APIConfiguration.swift
//  Vitesse
//
//  Created by Tony Stark on 27/11/2024.
//
import Foundation

struct APIConstants {
    static let baseURL = "http://127.0.0.1:8080"
}

enum APIEndpoint {
    case checkAPI
    case authenticate
    case register
    case getCandidates
    case getCandidateDetail(id: String)
    case createCandidate
    case updateCandidate(id: String)
    case deleteCandidate(id: String)
    case toggleFavoriteCandidate(id: String)
    case custom(path: String)

    private var candidateBase: String {
        return "/candidate"
    }

    private var userBase: String {
        return "/user"
    }

    var path: String {
        switch self {
        case .checkAPI:
            return ""
        case .authenticate:
            return "\(userBase)/auth"
        case .register:
            return "\(userBase)/register"
        case .getCandidates:
            return candidateBase
        case .getCandidateDetail(let id):
            return "\(candidateBase)/\(id)"
        case .createCandidate:
            return candidateBase
        case .updateCandidate(let id):
            return "\(candidateBase)/\(id)"
        case .deleteCandidate(let id):
            return "\(candidateBase)/\(id)"
        case .toggleFavoriteCandidate(let id):
            return "\(candidateBase)/\(id)/favorite"
        case .custom(let path):
            return path
        }
    }

    var url: URL? {
        return URL(string: APIConstants.baseURL + path)
    }
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}
