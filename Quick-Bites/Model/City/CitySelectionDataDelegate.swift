//
//  CityDataDelegate.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 25.12.2022.
//

import Foundation

protocol CitySelectionDataDelegate {
    func citiesLoaded()
    func refreshTokenExpired()
}
