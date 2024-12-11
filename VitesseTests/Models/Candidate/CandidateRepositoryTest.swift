//
//  CandidateRepositoryTest.swift
//  VitesseTests
//
//  Created by Tony Stark on 05/12/2024.
//
@testable import Vitesse
import XCTest

//final class CandidateRepositoryTests: XCTestCase {
//    func testFetchCandidates_withValidToken_shouldReturnCandidates() {
//        // Remplacez ce token par un token valide pour tester
//        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc0FkbWluIjp0cnVlLCJlbWFpbCI6ImFkbWluQHZpdGVzc2UuY29tIn0.jwtsrxgCQYhf1cUvhnNC8UlF9KwFV16klnHI-t_w3R8"
//        let repository = CandidateRepository(authToken: token)
//
//        // Utiliser une expectation pour attendre la réponse
//        let expectation = self.expectation(description: "Fetching candidates")
//
//        repository.fetchCandidates { result in
//            switch result {
//            case .success(let candidates):
//                print("✅ \(candidates.count) candidats récupérés:")
//                for candidate in candidates {
//                    print(" - \(candidate)")
//                }
//                XCTAssertTrue(!candidates.isEmpty, "La liste des candidats ne devrait pas être vide.")
//            case .failure(let error):
//                print("❌ Erreur: \(error.localizedDescription)")
//                XCTFail("La récupération des candidats a échoué: \(error.localizedDescription)")
//            }
//
//            expectation.fulfill()
//        }
//
//        // Attendre une réponse avec un timeout de 10 secondes
//        wait(for: [expectation], timeout: 10.0)
//    }
//}
