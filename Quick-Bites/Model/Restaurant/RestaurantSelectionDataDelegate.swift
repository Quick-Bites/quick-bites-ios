//
//  RestaurantSelectionDataDelegate.swift
//  Quick-Bites
//
//  Created by Can Usluel on 2.01.2023.
//

import Foundation

protocol RestaurantSelectionDataDelegate: AnyObject {
    func restaurantsLoaded()
    func restaurantDetailsLoaded(restaurant: Restaurant)
    func refreshTokenExpired()
}

extension RestaurantSelectionDataDelegate {
    func restaurantsLoaded() { }
    func restaurantDetailsLoaded(restaurant: Restaurant) { }
    func refreshTokenExpired() {}
}
