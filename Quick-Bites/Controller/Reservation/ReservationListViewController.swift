//
//  ReservationListViewController.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 2.01.2023.
//

import UIKit

class ReservationListViewController: UIViewController {

    @IBOutlet weak var userReservationsTableView: UITableView!
    private let userReservationDataSource = UserInfoDataSource()
    var userReservations: [Reservation?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userReservationDataSource.delegate = self
        userReservationDataSource.getReservedRestaurants()
        self.title = "Reservations"

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let cell = sender as? UITableViewCell,
            let indexPath = userReservationsTableView.indexPath(for: cell),
            let restaurant = userReservationDataSource.getReservedRestaurant(for: indexPath.row),
            let reservationDetailController = segue.destination as? ReservationDetailViewController,
            let reservation = userReservations?[indexPath.row]
        {
            reservationDetailController.restaurant = restaurant
            reservationDetailController.reservation = reservation
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userReservationDataSource.getReservedRestaurants()
        userReservationDataSource.getUserDetails()
    }
    
}

extension ReservationListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userReservationDataSource.getNumberOfReservedRestaurants()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserReservationCell") as? UserReservationTableViewCell
            else {
            return UITableViewCell()
        }

        if
            let restaurant = userReservationDataSource.getReservedRestaurant(for: indexPath.row) {
                cell.userReservationRestaurantNameLabel.text = restaurant.name
        } else {
            cell.userReservationRestaurantNameLabel.text = ""
        }

        return cell
    }
    
    
}

extension ReservationListViewController: UserInfoDataDelegate {
    func userReservationsLoaded() {
        userReservationsTableView.reloadData()
    }
    
    func refreshTokenExpired() {
        PresenterManager.shared.show(vc: .login)
    }
    
    func userInfoLoaded(user: User) {
        userReservations = user.reservations
        
        if user.reservations.count == 0 {
            _ = self.navigationController?.popViewController(animated: true)
            
        }
    }
    
}
