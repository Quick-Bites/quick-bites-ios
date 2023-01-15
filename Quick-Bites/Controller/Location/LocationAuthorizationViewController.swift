//
//  LocationPrepareViewController.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 14.01.2023.
//

import UIKit

class LocationAuthorizationViewController: UIViewController {
    private let locationHelper = LocationHelper()
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    private var authorizationGiven: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
        // Do any additional setup after loading the view.
        locationHelper.delegate = self
        authorizationGiven = locationHelper.isAuthorized()
        if let authorizationGiven = self.authorizationGiven {
            if authorizationGiven {
                print("Authorization is given")
            } else {
                PresenterManager.shared.show(nextViewController: .location)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LocationAuthorizationViewController: LocationDelegate {
    func cityNameFound(cityName: String) {
        PresenterManager.shared.show(nextViewController: .category)
    }
}
