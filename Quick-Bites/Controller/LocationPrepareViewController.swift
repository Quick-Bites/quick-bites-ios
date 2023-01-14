//
//  LocationPrepareViewController.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 14.01.2023.
//

import UIKit

class LocationPrepareViewController: UIViewController {
    private let locationHelper = LocationHelper()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationHelper.delegate = self

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

extension LocationPrepareViewController: LocationDelegate {
    func authorizationGiven() {
        print("Authorization is given before.")
    }
    func authorizationNotGiven() {
        print("Authorization is not given")
    }
}
