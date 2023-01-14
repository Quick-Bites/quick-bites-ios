//
//  ReservationDetailViewController.swift
//  Quick-Bites
//
//  Created by Can Usluel on 8.01.2023.
//

import UIKit

class ReservationDetailViewController: UIViewController {
    
    var restaurant: Restaurant?
    var reservation: Reservation?
    @IBOutlet weak var reservationStartTimeLabel: UILabel!
    @IBOutlet weak var reservationEndTimeLabel: UILabel!
    @IBOutlet weak var numberOfGuestsLabel: UILabel!
    @IBOutlet weak var restaurantPhoneNumberLabel: UILabel!
    private var dataSource = ReservationDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataSource.delegate = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if
            let restaurant,
            let reservation
        {
            numberOfGuestsLabel.text = "Number of Guests: \(reservation.numGuests)"
            restaurantPhoneNumberLabel.text = "Restaurant's Phone Number: \(restaurant.phoneNumber)"
            self.title = "Reservation Details of \(restaurant.name)"
            if
                let startDate = dateFormatter.date(from: reservation.startTime),
                let endDate = dateFormatter.date(from: reservation.endTime) {
                
                let modifiedStartDate = startDate.description.replacingOccurrences(of: "+0000", with: "")
                let modifiedEndDate = endDate.description.replacingOccurrences(of: "+0000", with: "")
                    reservationStartTimeLabel.text = "Start time: \(modifiedStartDate)"
                    reservationEndTimeLabel.text = "End time: \(modifiedEndDate)"
            }else {
                print("error")
            }
        }
    }
    

    @IBAction func cancelReservation(_ sender: Any) {
        if
            let reservationId = reservation?.id {
            dataSource.cancelReservation(with: String(reservationId))
        }
    }
}

extension ReservationDetailViewController: ReservationDataDelegate {
    func reservationConfirmed(isConfirmed: Bool) {
        let alert = UIAlertController(title: "Reservation Failed", message: "The restaurant is not available for the given time or guest number.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default)
        let okayActionWithPop = UIAlertAction(title: "Okay", style: .default){_ in
            _ = self.navigationController?.popViewController(animated: true)

        }

        if isConfirmed {
            alert.title = "Reservation Confirmed"
            alert.message = "You have successfuly made a reservation."
            alert.addAction(okayActionWithPop)
            present(alert, animated: true, completion: nil)
        }else {
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)

        }

    }
    
    func refreshTokenExpired() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func reservationCanceled() {
        let alert = UIAlertController(title: "Reservation Cancelled", message: "The reservation on this page has been cancelled.", preferredStyle: .alert)
        let okayActionWithPop = UIAlertAction(title: "Okay", style: .default){_ in
            _ = self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okayActionWithPop)
        present(alert, animated: true, completion: nil)
    }
    
    func reservationCancelFailed() {
        let alert = UIAlertController(title: "Reservation Cancel Failed", message: "The procces of canceling reservation has been failed, please contact us for the problem.", preferredStyle: .alert)
        let okayActionWithPop = UIAlertAction(title: "Okay", style: .default){_ in
            _ = self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okayActionWithPop)
        present(alert, animated: true, completion: nil)
    }
    
}
