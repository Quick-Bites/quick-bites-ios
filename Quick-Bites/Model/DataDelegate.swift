//
//  DataDelegate.swift
//  Quick-Bites
//
//  Created by Can Usluel on 24.12.2022.
//

import Foundation

protocol DataDelegate {
    
    func userLoggedIn()
    func userSignedIn()
    
}

extension DataDelegate {
    
    func userLoggedIn() {}
    func userSignedIn() {}
}
