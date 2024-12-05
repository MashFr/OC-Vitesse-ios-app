//
//  UserDTO.swift
//  Vitesse
//
//  Created by Tony Stark on 03/12/2024.
//

import Foundation

//  DTO (Data Transfer Object)
struct UserDTO: Codable {
    let email: String
    let password: String
    var token: String?
    var isAdmin: Bool?
}
