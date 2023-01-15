//
//  RestaurantSelectionViewController.swift
//  Quick-Bites
//
//  Created by Can Usluel on 2.01.2023.
//

import UIKit

class RestaurantSelectionViewController: UIViewController {
    @IBOutlet weak var restaurantSelectionTableView: UITableView!
    var category: String?
    var cityName: String?
    private var restaurantSelectionDataSource = RestaurantSelectionDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Restaurants"
        restaurantSelectionDataSource.delegate = self
        if
            let category = category,
            let cityName = cityName
        {
            restaurantSelectionDataSource.getListOfRestaurants(with: cityName, with: category)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let cell = sender as? UITableViewCell,
            let indexPath = restaurantSelectionTableView.indexPath(for: cell),
            let restaurant = restaurantSelectionDataSource.getRestaurant(for: indexPath.row),
            let restaurantDetailController = segue.destination as? RestaurantDetailViewController
        {
            restaurantDetailController.restaurantName = restaurant.name
            restaurantDetailController.cityName = restaurant.locatedCity
            restaurantDetailController.restaurantId = String(restaurant.id)
        }
    }
}

extension RestaurantSelectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantSelectionDataSource.getNumberOfRestaurants()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as? RestaurantSelectionTableViewCell
            else {
            return UITableViewCell()
        }

        if let restaurant = restaurantSelectionDataSource.getRestaurant(for: indexPath.row) {
            cell.restaurantNameLabel.text = restaurant.name
        } else {
            cell.restaurantNameLabel.text = ""
        }

        return cell
    }
}

extension RestaurantSelectionViewController: RestaurantSelectionDataDelegate {
    func restaurantsLoaded() {
        self.restaurantSelectionTableView.reloadData()
    }

    func refreshTokenExpired() {
        PresenterManager.shared.show(nextViewController: .login)
    }
}
