//
//  CandidateDTO.swift
//  Vitesse
//
//  Created by Tony Stark on 03/12/2024.
//

import Foundation

//  DTO (Data Transfer Object)
struct CandidateDTO: Codable {
    let id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var phone: String?
    var linkedinURL: String?
    var note: String?
    var isFavorite: Bool
}
