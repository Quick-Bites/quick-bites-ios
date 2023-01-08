//
//  Reservation.swift
//  Quick-Bites
//
//  Created by Can Usluel on 3.01.2023.
//

import Foundation

struct Reservation: Decodable {
    let id: Int
    let startTime: String
    let endTime: String
    let numGuests: Int
}
