//
//  Restaurant.swift
//  Quick-Bites
//
//  Created by Can Usluel on 2.01.2023.
//

import Foundation

struct Restaurant: Decodable{
    let id: Int
    let name: String
    let locatedCity: String
    let address: String
    let phoneNumber: String
    let category: String
    let rating: String
    let capacity: Int
    let reservations: [String?]
}
