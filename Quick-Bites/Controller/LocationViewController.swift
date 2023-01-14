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
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: #selector(rightButtonTapped))
    }

    @objc func rightButtonTapped() {
        let storyboard = UIStoryboard(name: "UserInfo", bundle: nil)
        if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "UserInfoViewController") as? UserInfoViewController,
           let username = UserInfoDataSource.username {
            destinationViewController.username = username
            show(destinationViewController, sender: self)
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if
            let userInfoViewController = segue.destination as? UserInfoViewController
        {
            userInfoViewController.username = UserInfoDataSource.username
        }
    }


    @IBAction func askForPermission(_ sender: Any) {
        if let cityName = self.cityName {
            if let categoryViewController = self.instantiateCategoryViewController() {
                categoryViewController.cityName = cityName
                show(categoryViewController, sender: self)
            }
        } else {
            locationHelper.askForInUsePermission()
        }
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
            if citySelectionDataSource.getCityArray().contains(where: { $0.name.lowercased() == cityName.lowercased() }) {
                authorizationButton.isEnabled = true
                authorizationButton.alpha = 1
                authorizationButton.setTitle("Your Location: \(cityName)", for: .normal)
            } else {
                authorizationButton.isEnabled = false
                authorizationButton.alpha = 0.95
                authorizationButton.tintColor = .gray
                authorizationButton.setTitle("We don't support \(cityName) yet", for: .normal)
            }
        }
    }
}
