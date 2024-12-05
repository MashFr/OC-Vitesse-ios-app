//
//  APIConfiguration.swift
//  Vitesse
//
//  Created by Tony Stark on 27/11/2024.
//
import Foundation

struct APIService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    // Fonction pour les requêtes avec un retour décodable
    func fetchDecodable<T: Decodable>(
        endpoint: APIEndpoint,
        method: HTTPMethod,
        body: Data? = nil,
        headers: [String: String]? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        do {
            let request = try RequestBuilder.buildRequest(
                endpoint: endpoint,
                method: method,
                body: body,
                headers: headers
            )
            executeRequestWithDecoding(request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    // Fonction pour les requêtes sans retour
    func fetch(
        endpoint: APIEndpoint,
        method: HTTPMethod,
        body: Data? = nil,
        headers: [String: String]? = nil,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        do {
            let request = try RequestBuilder.buildRequest(
                endpoint: endpoint,
                method: method,
                body: body,
                headers: headers
            )
            executeRequest(request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    // Exécution des requêtes avec un retour décodable
    private func executeRequestWithDecoding<T: Decodable>(
        _ request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        session.dataTask(with: request) { data, response, error in
            // Gestion des erreurs réseaux
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.invalidResponse))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.httpError(statusCode: httpResponse.statusCode)))
                return
            }

            guard let data = data, data.isEmpty == false else {
                completion(.failure(APIError.noData))
                return
            }

            // Décodage du JSON en type T
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // Exécution des requêtes sans décodage
    private func executeRequest(
        _ request: URLRequest,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        session.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.invalidResponse))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.httpError(statusCode: httpResponse.statusCode)))
                return
            }

            // Si tout est ok, on retourne un succès sans données
            completion(.success(Void()))
        }.resume()
    }
}

// MARK: other way

// struct APIService {
//    private let session: URLSession
//
//    init(session: URLSession = .shared) {
//        self.session = session
//    }
//
//    func fetch<T: Decodable>(
//        endpoint: APIEndpoint,
//        method: HTTPMethod,
//        body: Data? = nil,
//        completion: @escaping (Result<T?, Error>) -> Void
//    ) {
//        do {
//            let request = try buildRequest(endpoint: endpoint, method: method, body: body)
//            executeRequest(request, decodeResponse: false, completion: completion)
//        } catch {
//            completion(.failure(error))
//        }
//    }
//
//    // Fonction pour les requêtes avec décodage de la réponse, comme GET ou POST
//    func fetchDecodable<T: Decodable>(
//        endpoint: APIEndpoint,
//        method: HTTPMethod,
//        body: Data? = nil,
//        completion: @escaping (Result<T?, Error>) -> Void
//    ) {
//        do {
//            let request = try buildRequest(endpoint: endpoint, method: method, body: body)
//            executeRequest(request, decodeResponse: true, completion: completion)
//        } catch {
//            completion(.failure(error))
//        }
//    }
//
//    func buildRequest(
//        endpoint: APIEndpoint,
//        method: HTTPMethod,
//        body: Data? = nil
//    ) throws -> URLRequest {
//        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
//            throw APIError.invalidURL
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        if let body = body {
//            request.httpBody = body
//        }
//
//        return request
//    }
//
//    // Fonction générique pour exécuter des requêtes HTTP
//    private func executeRequest<T: Decodable>(
//        _ request: URLRequest,
//        decodeResponse: Bool,
//        completion: @escaping (Result<T?, Error>) -> Void
//    ) {
//        session.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(.failure(APIError.invalidResponse))
//                return
//            }
//
//            // Vérification du code de statut HTTP
//            guard (200...299).contains(httpResponse.statusCode) else {
//                completion(.failure(APIError.httpError(statusCode: httpResponse.statusCode)))
//                return
//            }
//
//            // Si la requête ne nécessite pas de retour de données, on termine ici
//            if !decodeResponse {
//                completion(.success(nil))  // Si pas de données à décoder
//                return
//            }
//
//            // Si des données sont présentes, on tente de les décoder
//            guard let data = data else {
//                completion(.failure(APIError.noData))
//                return
//            }
//
//            do {
//                // Si la requête nécessite des données décodées, on essaie de les décoder
//                let decodedData = try JSONDecoder().decode(T.self, from: data)
//                completion(.success(decodedData))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
// }
