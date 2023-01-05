//
//  UserInfoDataSource.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 2.01.2023.
//

import UIKit

class UserInfoDataSource {

    var delegate: UserInfoDataDelegate?
    private let keychain = KeychainWrapper()

    init() {
    }

    func getUserDetails(for username: String) {
        let session = URLSession.shared
        if let url = URL(string: "\(Constants.getUserDetailsURL())/\(username)") {
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
                            let user = try decoder.decode(User.self, from: data)
                            DispatchQueue.main.async {
                                self.delegate?.userInfoLoaded(user: user)
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
                                self.getUserDetails(for: username)
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

    func getUserAvatar(for username: String) {
        if let url = URL(string: "https://avatars.dicebear.com/api/adventurer/\(username).png?size=128&b=lightgray&r=50") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("image/png", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data,
                   let image = UIImage(data: data),
                   let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            self.delegate?.userAvatarLoaded(image: image)
                        }
                    } else if httpResponse.statusCode == 403 {
                        print("Access token expired")
                        TokenDataSource.askForAccessToken { result in
                            switch result {
                            case .success(_):
                                // Access token is refreshed
                                self.getUserAvatar(for: username)
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
    }
}


