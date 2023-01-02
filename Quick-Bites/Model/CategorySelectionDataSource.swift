//
//  CategoryDataSource.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 31.12.2022.
//

import Foundation

class CategorySelectionDataSource {
    private var categoryArray: [Category] = []
    var delegate: CategorySelectionDataDelegate?
    private let keychain = KeychainWrapper()

    init() {
    }

    func getListOfCategories() {
        let session = URLSession.shared
        if let url = URL(string: Constants.getCategoriesURL()) {
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
                        self.categoryArray = try! decoder.decode([Category].self, from: data)
                        DispatchQueue.main.async {
                            self.delegate?.categoriesLoaded()
                        }
                    }
                    else if httpResponse.statusCode == 403 {
                        print("Access token was expired")
                        self.delegate?.accessTokenExpired()
                    }
                    else {
                        print("There is a problem \(httpResponse.description)")
                    }
                }
            }
            dataTask.resume()
        }
    }
 

    func getNumberOfCategories() -> Int {
        return categoryArray.count
    }

    func getCategory(for index:Int) -> Category? {
        guard index < categoryArray.count else {
            return nil
        }
        return categoryArray[index]
    }
}
