//
//  ReservationDataDelegate.swift
//  Quick-Bites
//
//  Created by Can Usluel on 8.01.2023.
//

import Foundation

protocol ReservationDataDelegate {
    func reservationConfirmed(isConfirmed: Bool)
    func refreshTokenExpired()
}
