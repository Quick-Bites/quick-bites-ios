//
//  ReservationDataDelegate.swift
//  Quick-Bites
//
//  Created by Can Usluel on 8.01.2023.
//

import Foundation

protocol ReservationDataDelegate: AnyObject {
    func reservationConfirmed(isConfirmed: Bool)
    func refreshTokenExpired()
    func reservationCanceled()
    func reservationCancelFailed()
}

extension ReservationDataDelegate {
    func reservationConfirmed(isConfirmed: Bool) {}
    func refreshTokenExpired() {}
    func reservationCanceled() {}
    func reservationCancelFailed() {}
}
