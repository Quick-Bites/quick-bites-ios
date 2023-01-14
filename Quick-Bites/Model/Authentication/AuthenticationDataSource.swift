//
//  DataSource.swift
//  Quick-Bites
//
//  Created by Can Usluel on 24.12.2022.
//

import Foundation

class AuthenticationDataSource {

    var delegate: AuthenticationDataDelegate?
    private let keychain = KeychainWrapper()

    init() {

    }

    func signUpUser(fullname: String, username: String, password: String, email: String, phoneNumber: String, address: String) {

        let url = URL(string: Constants.getRegisterURL())!
        let body = [
            "id": nil,
            "name": fullname,
            "username": username,
            "password": password,
            "email": email,
            "phoneNumber": phoneNumber,
            "address": address,
            "roles": nil
        ]
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode == 201 {
                    DispatchQueue.main.async {
                        self.delegate?.userSignedUp()
                    }
                } else {
                    return
                }
            }
        }
        task.resume()
    }

    func logInUser(username: String, password: String) {
        let url = URL(string: Constants.getLoginURL())!
        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let parameters: [String: String] = [
            "username": username,
            "password": password
        ]

        let data = parameters.map { "\($0)=\($1)" }.joined(separator: "&").data(using: .utf8)!
        request.httpBody = data

        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                    if let json = json {
                        let accessToken = json["access_token"]
                        let refreshToken = json["refresh_token"]
                        print("Access token: \(accessToken ?? "err")")
                        print("Refresh token: \(refreshToken ?? "err")")

                        if let accessTokenStr = accessToken,
                            let refreshTokenStr = refreshToken {
                            try self.keychain.addItem(account: "quick_bites_user", service: "quick_bites_access_token", password: accessTokenStr)
                            try self.keychain.addItem(account: "quick_bites_user", service: "quick_bites_refresh_token", password: refreshTokenStr)
                        }
                        
                        if let httpResponse = response as? HTTPURLResponse {
                            let statusCode = httpResponse.statusCode
                            if statusCode == 200 {
                                DispatchQueue.main.async {
                                    self.delegate?.userLoggedIn(username: username)
                                }
                            }
                        }
                        
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.delegate?.userLoginFailed()
                    }
                }
            }
        }

        task.resume()
    }
    
    func validateUser() {
        let session = URLSession.shared
        if let url = URL(string: "\(Constants.getUserDetailsURL())") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            if let token = try? keychain.searchItem(account: "quick_bites_user", service: "quick_bites_access_token") {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
                print("An error occurred")
            }

            let dataTask = session.dataTask(with: request) { data, response, error in
                if
                   let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                            DispatchQueue.main.async {
                                self.delegate?.userValidated()
                        }
                    } else if httpResponse.statusCode == 403 {
                        print("Access token expired")
                        TokenDataSource.askForAccessToken { result in
                            switch result {
                            case .success(_):
                                // Access token is refreshed
                                self.delegate?.userValidated()
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
}
