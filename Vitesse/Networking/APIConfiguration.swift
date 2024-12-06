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
        // todo: candidateBase
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
    let header: [String: String] = [:]

    enum ContentType: String {
        case json = "application/json"
        case xml = "application/xml"
        case formUrlEncoded = "application/x-www-form-urlencoded"
        case plainText = "text/plain"

        var contentTypeHeader: [String: String] {
            ["Content-Type": self.rawValue]
        }
    }

    enum Accept: String {
        case json = "application/json"
        case xml = "application/xml"
        case html = "text/html"

        var acceptHeader: [String: String] {
            ["Accept": self.rawValue]
        }
    }

    static func addAuthorization(token: String) -> [String: String] {
       return ["Authorization": "Bearer \(token)"]
    }
}
