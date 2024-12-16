//
//  User.swift
//  Vitesse
//
//  Created by Tony Stark on 27/11/2024.
//

// Login Request
struct AuthBody: Encodable {
    let email: String
    let password: String
}

// Login Response
struct AuthResponse: Codable {
    let token: String
    let isAdmin: Bool
}

// Signup Request
struct RegisterBody: Encodable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
}
