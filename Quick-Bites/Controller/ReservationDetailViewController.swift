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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
