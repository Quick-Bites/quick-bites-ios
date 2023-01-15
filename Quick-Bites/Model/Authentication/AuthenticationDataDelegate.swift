//
//  DataDelegate.swift
//  Quick-Bites
//
//  Created by Can Usluel on 24.12.2022.
//

import Foundation

protocol AuthenticationDataDelegate: AnyObject {

    func userLoggedIn(username: String)
    func userLoginFailed()
    func userSignedUp()
    func userSignedUpFailed()
    func refreshTokenExpired()
}

extension AuthenticationDataDelegate {

    func userLoggedIn(username: String) { }
    func userLoginFailed() { }
    func userSignedUp() { }
    func userSignedUpFailed() { }
    func refreshTokenExpired() { }
}
