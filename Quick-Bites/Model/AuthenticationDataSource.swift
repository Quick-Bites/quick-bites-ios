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
    
    init(){
        
    }
    
    func signUpUser(fullname:String, username:String, password:String, email:String, phoneNumber:String) {
        
        let url = URL(string: Constants.getRegisterURL())!
        let body = [
            "id": nil,
            "name": fullname,
            "username": username,
            "password": password,
            "email": email,
            "phoneNumber": phoneNumber,
            "address": "N/A",
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
                        self.delegate?.userSignedIn()
                    }
                }else{
                    return
                }
            }
        }
        task.resume()
    }
    
    func logInUser(username:String, password:String){
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
                            try self.keychain.addItem(account: "quick_bites_user", service: "quick_bits_refresh_token", password: refreshTokenStr)
                        }
                        
                        print(try self.keychain.searchItem(account: username, service: "quick_bites_access_token"))
                        
                        DispatchQueue.main.async {
                            self.delegate?.userLoggedIn()
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }

        task.resume()
    }
}
