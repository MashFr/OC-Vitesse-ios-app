//
//  User.swift
//  Vitesse
//
//  Created by Tony Stark on 27/11/2024.
//

struct User: Codable {
    let email: String
    let password: String
    var token: String?
    var isAdmin: Bool?
}
