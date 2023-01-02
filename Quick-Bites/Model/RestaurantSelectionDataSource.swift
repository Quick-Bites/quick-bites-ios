//
//  RestaurantSelectionDataSource.swift
//  Quick-Bites
//
//  Created by Can Usluel on 2.01.2023.
//

import Foundation

class RestaurantSelectionDataSource {
    private var restaurantArray: [Restaurant] = []
    var delegate: RestaurantSelectionDataDelegate?
    private let keychain = KeychainWrapper()
    
    func getListOfRestaurants(with city: String){
        let session = URLSession.shared
        if let url = URL(string: Constants.getCityRestaurantsURL(with: city)) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            if let token = try? keychain.searchItem(account: "quick_bites_user", service: "quick_bites_access_token") {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
                print("An error occurred")
            }
            
            let dataTask = session.dataTask(with: request) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    self.restaurantArray = try! decoder.decode([Restaurant].self, from: data)
                    DispatchQueue.main.async {
                        self.delegate?.restaurantsLoaded()
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func getListOfRestaurants(with city: String, with category: String){
        let session = URLSession.shared
        if let url = URL(string: Constants.getCityRestaurantsWithCategoryURL(with: city, with: category)) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            if let token = try? keychain.searchItem(account: "quick_bites_user", service: "quick_bites_access_token") {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
                print("An error occurred")
            }
            
            let dataTask = session.dataTask(with: request) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    self.restaurantArray = try! decoder.decode([Restaurant].self, from: data)
                    DispatchQueue.main.async {
                        self.delegate?.restaurantsLoaded()
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func getNumberOfRestaurants() -> Int{
        return restaurantArray.count
    }
    
    func getRestaurant(for index:Int) -> Restaurant?{
        guard index < restaurantArray.count else {
            return nil
        }
        return restaurantArray[index]
    }
}
