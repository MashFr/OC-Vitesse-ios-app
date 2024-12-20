//
//  CandidateSample.swift
//  Vitesse
//
//  Created by Tony Stark on 15/11/2024.
//
import Foundation

extension Candidate {

    init(firstName: String,
         id: UUID = UUID(),
         lastName: String,
         email: String,
         phone: String? = nil,
         linkedinURL: String? = nil,
         note: String? = nil,
         isFavorite: Bool = false) {

        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.linkedinURL = linkedinURL != nil ? URL(string: linkedinURL!) : nil
        self.note = note
        self.isFavorite = isFavorite
    }
}

var sampleCandidates: [Candidate] = [
    Candidate(
        firstName: "John",
        lastName: "Doe",
        email: "john.doe@example.com",
        phone: "+1234567890",
        linkedinURL: "https://www.linkedin.com/in/johndoe",
        note: "Experienced iOS Developer",
        isFavorite: true
    ),
    Candidate(
        firstName: "Jane",
        lastName: "Smith",
        email: "jane.smith@example.com",
        phone: "+0987654321",
        linkedinURL: "https://www.linkedin.com/in/janesmith",
        note: "Expert in Swift and SwiftUI",
        isFavorite: false
    ),
    Candidate(
        firstName: "Michael",
        lastName: "Johnson",
        email: "michael.j@example.com",
        phone: "+1230984567",
        linkedinURL: nil,
        note: "Great problem solver",
        isFavorite: false
    ),
    Candidate(
        firstName: "Emily",
        lastName: "Davis",
        email: "emily.davis@example.com",
        phone: "+7890123456",
        linkedinURL: "https://www.linkedin.com/in/emilydavis",
        note: "Specialized in UI/UX design",
        isFavorite: true
    )
]
