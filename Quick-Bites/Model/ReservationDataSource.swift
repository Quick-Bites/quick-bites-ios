//
//  ReservationDataSource.swift
//  Quick-Bites
//
//  Created by Can Usluel on 7.01.2023.
//

import Foundation

class ReservationDataSource {
    var delegate: ReservationDataDelegate?
    private let keychain = KeychainWrapper()
    
    func makeReservation(with startTime: String, with endTime: String, with numGuests: String, with restaurantId: String) {
        let url = URL(string: Constants.getMakeReservationURL())!
        let body = [
            "restaurantId": restaurantId,
            "startTime": startTime,
            "endTime": endTime,
            "numGuests": numGuests
        ]
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
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
                        let reservationResponse = try decoder.decode(ReservationResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.delegate?.reservationConfirmed(isConfirmed: reservationResponse.isSuccessful)
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
                            self.makeReservation(with: startTime, with: endTime, with: numGuests, with: restaurantId)
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
