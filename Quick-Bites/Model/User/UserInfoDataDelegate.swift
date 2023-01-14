//
//  UserInfoDataDelegate.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 2.01.2023.
//

import UIKit

protocol UserInfoDataDelegate {
    func userInfoLoaded(user: User)
    func userAvatarLoaded(image: UIImage)
    func userReservationsLoaded()
    func refreshTokenExpired()
    func userLoggedIn()
}

extension UserInfoDataDelegate {
    func userInfoLoaded(user: User) {}
    func userAvatarLoaded(image: UIImage) {}
    func userReservationsLoaded() {}
    func refreshTokenExpired() {}
    func userLoggedIn() {}
}
