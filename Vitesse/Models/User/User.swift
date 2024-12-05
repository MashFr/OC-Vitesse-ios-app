//
//  User.swift
//  Vitesse
//
//  Created by Tony Stark on 27/11/2024.
//

struct User {
    let email: String
    let password: String
    var token: String?
    var isAdmin: Bool?
}

// MARK: - Conversion methods between User and UserDTO
extension User {
    init(from dto: UserDTO) {
        self.email = dto.email
        self.password = dto.password
        self.token = dto.token
        self.isAdmin = dto.isAdmin
    }

    func toDTO() -> UserDTO {
        return UserDTO(
            email: self.email,
            password: self.password,
            token: self.token,
            isAdmin: self.isAdmin
        )
    }
}

// Login Request
struct AuthBody: Codable {
    let email: String
    let password: String
}

// Login Response
struct AuthResponse: Codable {
    let token: String
    let isAdmin: Bool
}

// Signup Request
struct RegisterBody: Codable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
}
