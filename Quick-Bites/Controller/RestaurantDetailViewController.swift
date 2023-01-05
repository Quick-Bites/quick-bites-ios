//
//  RestaurantDetailViewController.swift
//  Quick-Bites
//
//  Created by Can Usluel on 2.01.2023.
//

import UIKit

class RestaurantDetailViewController: UIViewController {

    var restaurantName: String?
    var cityName: String?
    private var restaurantSelectionDataSource = RestaurantSelectionDataSource()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        restaurantSelectionDataSource.delegate = self
        if
            let restaurantName,
            let cityName
        {
            self.title = "\(restaurantName) Details"
            restaurantSelectionDataSource.getRestaurantDetails(with: cityName, with: restaurantName)
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

extension RestaurantDetailViewController: RestaurantSelectionDataDelegate {
    func restaurantDetailsLoaded(restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        addressLabel.text = restaurant.address
        phoneNumberLabel.text = restaurant.phoneNumber
        ratingLabel.text = restaurant.rating
    }
    
    func refreshTokenExpired() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
