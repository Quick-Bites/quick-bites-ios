//
//  LocationViewController.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 30.12.2022.
//

import UIKit

class LocationViewController: UIViewController {

    private var locationHelper = LocationHelper()
    
    @IBOutlet weak var authorizationButton: UIButton!
    private var cityName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        locationHelper.delegate = self
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func askForPermission(_ sender: Any) {
        if let cityName = self.cityName {
            if let nextViewController = self.continueNextView() {
                show(nextViewController, sender: self)
            }
        } else {
            locationHelper.askForInUsePermission()
        }
    }
    
    func continueNextView() -> UIViewController? {
        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") else { print("CategoryViewController not found!")
            return nil }
        return nextViewController
    }
}

extension LocationViewController: LocationDelegate {
    func cityNameFound(cityName: String) {
        print("City is found")
        self.cityName = cityName
        if let cityName = self.cityName {
            authorizationButton.setTitle("Your Location: \(cityName)", for: .normal)
        }
    }
}
