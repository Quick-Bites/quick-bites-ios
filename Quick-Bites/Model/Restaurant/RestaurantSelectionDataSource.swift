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

    func getListOfRestaurants(with city: String) {
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
                if let data = data,
                   let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        let decoder = JSONDecoder()
                        do {
                            self.restaurantArray = try decoder.decode([Restaurant].self, from: data)
                        } catch {
                            print(error)
                        }
                        DispatchQueue.main.async {
                            self.delegate?.restaurantsLoaded()
                        }
                    } else if httpResponse.statusCode == 403 {
                        print("Access token expired")
                        TokenDataSource.askForAccessToken { result in
                            switch result {
                            case .success(_):
                                // Access token is refreshed
                                self.getListOfRestaurants(with: city)
                            case .failure(let error):
                                // Refresh token expired
                                print(error)
                                DispatchQueue.main.async {
                                    self.delegate?.refreshTokenExpired()
                                }
                            }
                        }
                    }
                }
            }
            dataTask.resume()
        }
    }

    func getListOfRestaurants(with city: String, with category: String) {
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
                if let data = data,
                   let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        let decoder = JSONDecoder()
                        do {
                            self.restaurantArray = try decoder.decode([Restaurant].self, from: data)
                        } catch {
                            print(error)
                        }
                        DispatchQueue.main.async {
                            self.delegate?.restaurantsLoaded()
                        }
                    } else if httpResponse.statusCode == 403 {
                        print("Access token expired")
                        TokenDataSource.askForAccessToken { result in
                            switch result {
                            case .success(_):
                                // Access token is refreshed
                                self.getListOfRestaurants(with: city, with: category)
                            case .failure(let error):
                                // Refresh token expired
                                print(error)
                                DispatchQueue.main.async {
                                    self.delegate?.refreshTokenExpired()
                                }
                            }
                        }
                    }
                }
            }
            dataTask.resume()
        }
    }

    func getRestaurantDetails(with restaurantId: String) {
        let url = URL(string: "\(Constants.getRestaurantDetailsURL())/\(restaurantId)")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = try? keychain.searchItem(account: "quick_bites_user", service: "quick_bites_access_token") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("An error occurred")
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let data = data,
               let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        let restaurant = try decoder.decode(Restaurant.self, from: data)
                        DispatchQueue.main.async {
                            self.delegate?.restaurantDetailsLoaded(restaurant: restaurant)
                        }
                    } catch {
                        print(error)
                    }
                } else if httpResponse.statusCode == 403 {
                    print("Access token expired")
                    TokenDataSource.askForAccessToken { result in
                        switch result {
                        case .success(_):
                            // Access token is refreshed
                            self.getRestaurantDetails(with: restaurantId)
                        case .failure(let error):
                            // Refresh token expired
                            print(error)
                            DispatchQueue.main.async {
                                self.delegate?.refreshTokenExpired()
                            }
                        }
                    }
                }
            }
        }
        task.resume()
    }

    func getNumberOfRestaurants() -> Int {
        return restaurantArray.count
    }

    func getRestaurant(for index: Int) -> Restaurant? {
        guard index < restaurantArray.count else {
            return nil
        }
        return restaurantArray[index]
    }
}