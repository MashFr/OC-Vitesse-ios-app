//
//  Candidate.swift
//  Vitesse
//
//  Created by Tony Stark on 15/11/2024.
//
import Foundation

struct Candidate: Identifiable, Hashable {
    let id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var phone: String?
    var linkedinURL: URL?
    var note: String?
    var isFavorite: Bool
}

// Conversion methods between Candidate and CandidateDTO
extension Candidate {
    init(from dto: CandidateDTO) {
        self.id = dto.id
        self.firstName = dto.firstName
        self.lastName = dto.lastName
        self.email = dto.email
        self.phone = dto.phone
        if let linkedinURL = dto.linkedinURL {
            self.linkedinURL = URL(string: linkedinURL)
        } else {
            self.linkedinURL = nil
        }
        self.note = dto.note
        self.isFavorite = dto.isFavorite
    }

    func toDTO() -> CandidateDTO {
        return CandidateDTO(
            id: self.id,
            firstName: self.firstName,
            lastName: self.lastName,
            email: self.email,
            phone: self.phone,
            linkedinURL: self.linkedinURL?.absoluteString,
            note: self.note,
            isFavorite: self.isFavorite
        )
    }
}
