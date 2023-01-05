//
//  CityDataSource.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 25.12.2022.
//

import Foundation

class CitySelectionDataSource {
    private var cityArray: [City] = []
    var delegate: CitySelectionDataDelegate?
    private let keychain = KeychainWrapper()

    init() {
    }

    func getListOfCities() {
        let session = URLSession.shared
        if let url = URL(string: Constants.getCitySelectionURL()) {
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
                    self.cityArray = try! decoder.decode([City].self, from: data)
                    DispatchQueue.main.async {
                        self.delegate?.citiesLoaded()
                    }

                }
            }
            dataTask.resume()
        }
    }


    func getNumberOfCities() -> Int {
        return cityArray.count
    }

    func getCity(for index: Int) -> City? {
        guard index < cityArray.count else {
            return nil
        }
        return cityArray[index]
    }
}
