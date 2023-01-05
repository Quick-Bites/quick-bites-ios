//
//  Constants.swift
//  Quick-Bites
//
//  Created by Can Usluel on 24.12.2022.
//

import Foundation

class Constants {
    static let baseURL = "x"

    static func getLoginURL() -> String {
        return "\(baseURL)/api/login"
    }

    static func getRegisterURL() -> String {
        return "\(baseURL)/api/user/register"
    }

    static func getCitySelectionURL() -> String {
        return "\(baseURL)/api/cities"
    }

    static func getCategoriesURL() -> String {
        return "\(baseURL)/api/restaurant/categories"
    }
    static func getCityRestaurantsURL(with city: String) -> String {
        return "\(baseURL)/api/restaurant/located-city/\(city)"
    }
    static func getCityRestaurantsWithCategoryURL(with city: String, with category: String) -> String {
        return "\(baseURL)/api/restaurant/category/\(category)/city/\(city)"
    }

    static func getRestaurantDetailsURL() -> String {
        return "\(baseURL)/api/restaurant/details"
    }

    static func getUserDetailsURL() -> String {
        return "\(baseURL)/api/user/details"
    }
}
