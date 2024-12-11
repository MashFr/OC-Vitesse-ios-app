//
//  GivenByTutor.swift
//  Vitesse
//
//  Created by Tony Stark on 03/12/2024.
//
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
