//
//  UserInfoDataSource.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 2.01.2023.
//

import Foundation

class UserInfoDataSource {
    
    var delegate: UserInfoDataDelegate?
    private let keychain = KeychainWrapper()

    init() {
    }

    func getUserDetails(for username: String) {
        let session = URLSession.shared
        if let url = URL(string: "\(Constants.getCategoriesURL())/\(username)") {
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
                    let user = try! decoder.decode(User.self, from: data)
                    DispatchQueue.main.async {
                        self.delegate?.userInfoLoaded(user: user)
                    }
                }
            }
            dataTask.resume()
        }
    }
}
