//
//  TokenDataSource.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 5.01.2023.
//

import Foundation

enum TokenError: Error {
    case noData
    case refreshTokenExpired
}

class TokenDataSource {
    private static let keychain = KeychainWrapper()
    
    init() {
        
    }
    
    static func askForAccessToken(completion: @escaping (Result<Data, Error>) -> Void){
        let session = URLSession.shared
        if let url = URL(string: Constants.getRefreshURL()) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            if let token = try? keychain.searchItem(account: "quick_bites_user", service: "quick_bites_refresh_token") {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
                print("An error occurred")
            }
            
            let dataTask = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
                if  let data = data,
                    let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 403 {
                        DispatchQueue.main.async {
                            completion(.failure(TokenError.refreshTokenExpired))
                        }
                    }
                    if httpResponse.statusCode == 200 {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                            if let json = json,
                               let accessToken = json["access_token"]
                            {
                                try? self.keychain.deleteItem(account: "quick_bites_user", service: "quick_bites_access_token")
                                try? self.keychain.addItem(account: "quick_bites_user", service: "quick_bites_access_token", password: accessToken)
                                DispatchQueue.main.async {
                                    completion(.success(data))
                                }
                            }
                        } catch {
                            print(error)
                        }
                        
                    }
                }
            }
            dataTask.resume()
        }
        }
    }
    


