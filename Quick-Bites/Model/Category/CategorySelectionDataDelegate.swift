//
//  CategoryDataDelegate.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 31.12.2022.
//

import Foundation

protocol CategorySelectionDataDelegate: AnyObject {
    func categoriesLoaded()
    func refreshTokenExpired()
}
