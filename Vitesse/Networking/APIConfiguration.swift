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

    var path: String {
        switch self {
        case .checkAPI:
            return ""
        case .authenticate:
            return "/user/auth"
        case .register:
            return "/user/register"
        case .getCandidates:
            return "/candidate"
        case .getCandidateDetail(let id):
            return "/candidate/\(id)"
        case .createCandidate:
            return "/candidate"
        case .updateCandidate(let id):
            return "/candidate/\(id)"
        case .deleteCandidate(let id):
            return "/candidate/\(id)"
        case .toggleFavoriteCandidate(let id):
            return "/candidate/\(id)/favorite"
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

struct HTTPHeaders {
   static func authorization(token: String) -> [String: String] {
       return ["Authorization": "Bearer \(token)"]
   }

   static let jsonContentType = ["Content-Type": "application/json"]
}
