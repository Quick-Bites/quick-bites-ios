//
//  User.swift
//  Quick-Bites
//
//  Created by Can Usluel on 24.12.2022.
//

import Foundation

struct User: Decodable {
    let name: String
    let username: String
    let email: String
    let phoneNumber: String
    let reservations: [String?]
}
