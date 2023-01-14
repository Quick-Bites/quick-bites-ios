//
//  LocationDelegate.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 30.12.2022.
//

import Foundation

protocol LocationDelegate: AnyObject {
    func cityNameFound(cityName: String)
    func authorizationGiven()
    func authorizationNotGiven()
}

extension LocationDelegate {
    func cityNameFound(cityName: String) {}
    func authorizationGiven() {}
    func authorizationNotGiven() {}
}
