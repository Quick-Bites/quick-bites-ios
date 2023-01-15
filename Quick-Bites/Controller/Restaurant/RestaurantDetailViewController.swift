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
    var restaurantId: String?
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
            let restaurantId,
            let restaurantName
        {
            self.title = "\(restaurantName) Details"
            restaurantSelectionDataSource.getRestaurantDetails(with: restaurantId)
        }

    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let reservationController = segue.destination as? ReservationViewController {
            reservationController.restaurantId = restaurantId
        }
        
    }
    

}

extension RestaurantDetailViewController: RestaurantSelectionDataDelegate {
    func restaurantDetailsLoaded(restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        addressLabel.text = restaurant.address
        phoneNumberLabel.text = restaurant.phoneNumber
        ratingLabel.text = restaurant.rating
        restaurantId = String(restaurant.id)
    }
    
    func refreshTokenExpired() {
        PresenterManager.shared.show(vc: .login)
    }
}
