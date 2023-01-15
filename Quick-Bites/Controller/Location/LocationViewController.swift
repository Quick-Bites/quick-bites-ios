//
//  LocationViewController.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 30.12.2022.
//

import UIKit

class LocationViewController: UIViewController {

    private var locationHelper = LocationHelper()
    private var citySelectionDataSource = CitySelectionDataSource()

    @IBOutlet weak var authorizationButton: UIButton!
    private var cityName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Quick Bites"
        locationHelper.delegate = self
        citySelectionDataSource.getListOfCities()
    }

    @IBAction func exploreButtonTapped(_ sender: Any) {
        PresenterManager.shared.show(nextViewController: .category)
    }

    @IBAction func askForPermission(_ sender: Any) {
        print("Girdi")
        locationHelper.askForInUsePermission()
    }

    func instantiateCategoryViewController() -> CategorySelectionViewController? {
        guard let categoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") else { print("CategoryViewController not found!")
            return nil }
        return categoryViewController as? CategorySelectionViewController
    }
}

extension LocationViewController: LocationDelegate {
    func cityNameFound(cityName: String) {
        self.cityName = cityName
        if let cityName = self.cityName {
            if CitySelectionDataSource.cityArray.contains(where: { $0.name.lowercased() == cityName.lowercased() }) {
                authorizationButton.isEnabled = true
                authorizationButton.alpha = 1
                authorizationButton.setTitle("Your Location: \(cityName)", for: .normal)
                PresenterManager.shared.show(nextViewController: .category)
            } else {
                authorizationButton.isEnabled = false
                authorizationButton.alpha = 0.95
                authorizationButton.tintColor = .gray
                authorizationButton.setTitle("We don't support \(cityName) yet", for: .normal)
            }
        }
    }
}
