//
//  APIConfiguration.swift
//  Vitesse
//
//  Created by Tony Stark on 27/11/2024.
//
import Foundation

/// A service that handles API requests and returns raw data.
struct APIService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    /// A function to perform a network request that returns raw data.
    func fetch(
        endpoint: APIEndpoint,
        method: HTTPMethod,
        body: Data? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<Data?, Error>) -> Void
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

    /// Executes a network request and returns raw data.
    private func executeRequest(
        _ request: URLRequest,
        completion: @escaping (Result<Data?, Error>) -> Void
    ) {
        session.dataTask(with: request) { data, response, error in
            // Handle network errors
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

            // Return the raw data
            completion(.success(data))
        }.resume()
    }

    // MARK: - Utils

    /// Fetch raw data and decode it into a Decodable type.
    func fetchAndDecode<T: Decodable>(
        endpoint: APIEndpoint,
        method: HTTPMethod,
        body: Data? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        fetch(endpoint: endpoint, method: method, body: body, headers: headers) { result in
            switch result {
            case .success(let resultData):
                guard let data = resultData, data.isEmpty == false else {
                    completion(.failure(APIError.noData))
                    return
                }

                let decodeResult: Result<T, Error> = ResponseDecoder.decode(data, to: T.self)
                completion(decodeResult)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
