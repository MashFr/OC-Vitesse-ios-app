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
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        do {
            let request = try buildRequest(endpoint: endpoint, method: method, body: body)
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
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        do {
            let request = try buildRequest(endpoint: endpoint, method: method, body: body)
            executeRequest(request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    func buildRequest(
        endpoint: APIEndpoint,
        method: HTTPMethod,
        body: Data? = nil
    ) throws -> URLRequest {
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            request.httpBody = body
        }

        return request
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

            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            // Décodage du JSON en type T
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(APIError.decodingError))
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
            completion(.success(()))
        }.resume()
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
//    if let headers = headers {
//        for (key, value) in headers {
//            setValue(value, forHTTPHeaderField: key)
//        }
//    }

// struct HTTPHeaders {
//    static func authorization(token: String) -> [String: String] {
//        return ["Authorization": "Bearer \(token)"]
//    }
//
//    static let jsonContentType = ["Content-Type": "application/json"]
// }

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
//            if error != nil {
//                completion(.failure(APIError.unknownError))
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
//                completion(.failure(APIError.decodingError))
//            }
//        }.resume()
//    }
// }

// MARK: ----------

//    class NetworkService {
//        private let session: URLSession
//
//        // Injection de dépendance via l'initialiseur
//        init(session: URLSession = .shared) {
//            self.session = session
//        }
//
//        // Méthode générique pour récupérer et décoder les données
//        func fetchDecodable<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
//            let task = session.dataTask(with: url) { data, response, error in
//                // Gérer les erreurs réseau
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//
//                guard let data = data else {
//                    completion(.failure(NSError(domain: "NoDataError", code: -1, userInfo: nil)))
//                    return
//                }
//
//                do {
//                    // Décodage du JSON en type T
//                    let decodedData = try JSONDecoder().decode(T.self, from: data)
//                    completion(.success(decodedData))
//                } catch {
//                    completion(.failure(error))
//                }
//            }
//            task.resume()
//        }
//    }

// MARK: TEST & MOCK -------------

//    class URLSessionMock: URLSession {
//        private let mockData: Data?
//        private let mockError: Error?
//
//        init(mockData: Data?, mockError: Error?) {
//            self.mockData = mockData
//            self.mockError = mockError
//        }
//
//        override func dataTask(
//            with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//            return URLSessionDataTaskMock {
//                completionHandler(self.mockData, nil, self.mockError)
//            }
//        }
//    }
//
//    func testNetworkService() {
//        let mockData = "Test Data".data(using: .utf8)
//        let mockSession = URLSessionMock(mockData: mockData, mockError: nil)
//        let networkService = NetworkService(session: mockSession)
//
//        let url = URL(string: "https://example.com")!
//        networkService.fetchData(from: url) { data, error in
//            assert(data == mockData, "Les données reçues ne correspondent pas aux données simulées.")
//            assert(error == nil, "Aucune erreur ne devait être retournée.")
//            print("Test réussi!")
//        }
//    }

//    func testFetchDecodable() {
//        let mockJSON = """
//        {
//            "id": 1,
//            "title": "Test Title",
//            "body": "This is a test body."
//        }
//        """.data(using: .utf8)
//
//        let mockSession = URLSessionMock(mockData: mockJSON, mockError: nil)
//        let networkService = NetworkService(session: mockSession)
//        let url = URL(string: "https://example.com")!
//
//        networkService.fetchDecodable(from: url) { (result: Result<Post, Error>) in
//            switch result {
//            case .success(let post):
//                assert(post.id == 1, "L'ID du post devrait être 1")
//                assert(post.title == "Test Title", "Le titre du post est incorrect")
//                print("Test réussi!")
//            case .failure(let error):
//                assert(false, "Le test a échoué avec l'erreur : \(error)")
//            }
//        }
//    }

// MARK: --------------------------
// import Foundation
//
// struct APIService {
//    private let session: URLSession
//
//    init(session: URLSession = .shared) {
//        self.session = session
//    }
//
//    // Fonction pour les requêtes avec un retour décodable
//    func fetchDecodable<T: Decodable>(
//        endpoint: APIEndpoint,
//        method: HTTPMethod,
//        body: Data? = nil,
//        completion: @escaping (Result<T, Error>) -> Void
//    ) {
//        do {
//            let request = try buildRequest(endpoint: endpoint, method: method, body: body)
//            executeRequestWithDecoding(request, completion: completion)
//        } catch {
//            completion(.failure(error))
//        }
//    }
//
//    // Fonction pour les requêtes sans retour
//    func fetch(
//        endpoint: APIEndpoint,
//        method: HTTPMethod,
//        body: Data? = nil,
//        completion: @escaping (Result<Void, Error>) -> Void
//    ) {
//        do {
//            let request = try buildRequest(endpoint: endpoint, method: method, body: body)
//            executeRequest(request, completion: completion)
//        } catch {
//            completion(.failure(error))
//        }
//    }
//
//    // Construction de la requête
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
//    // Exécution des requêtes avec un retour décodable
//    private func executeRequestWithDecoding<T: Decodable>(
//        _ request: URLRequest,
//        completion: @escaping (Result<T, Error>) -> Void
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
//            guard (200...299).contains(httpResponse.statusCode) else {
//                completion(.failure(APIError.httpError(statusCode: httpResponse.statusCode)))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(APIError.noData))
//                return
//            }
//
//            do {
//                let decodedData = try JSONDecoder().decode(T.self, from: data)
//                completion(.success(decodedData))
//            } catch {
//                completion(.failure(APIError.decodingError))
//            }
//        }.resume()
//    }
//
//    // Exécution des requêtes sans décodage
//    private func executeRequest(
//        _ request: URLRequest,
//        completion: @escaping (Result<Void, Error>) -> Void
//    ) {
//        session.dataTask(with: request) { _, response, error in
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
//            guard (200...299).contains(httpResponse.statusCode) else {
//                completion(.failure(APIError.httpError(statusCode: httpResponse.statusCode)))
//                return
//            }
//
//            // Si tout est ok, on retourne un succès sans données
//            completion(.success(()))
//        }.resume()
//    }
// }
