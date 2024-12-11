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
struct AuthResponse: Decodable {
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

//    struct User {
//        let email: String
//        var firstName: String
//        var lastName: String
//        let password: String
//        var token: String?
//        var isAdmin: Bool?
//    }
//
//    // MARK: - Conversion methods between User and UserDTO
//    extension User {
//        init(from dto: UserDTO) {
//            self.email = dto.email
//            self.firstName = dto.firstName
//            self.lastName = dto.lastName
//            self.password = dto.password
//            self.token = dto.token
//            self.isAdmin = dto.isAdmin
//        }
//
//        func toDTO() -> UserDTO {
//            return UserDTO(
//                email: self.email,
//                firstName: self.firstName,
//                lastName: self.lastName,
//                password: self.password,
//                token: self.token,
//                isAdmin: self.isAdmin
//            )
//        }
//    }
