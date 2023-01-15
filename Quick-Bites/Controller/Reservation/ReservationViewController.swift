//
//  ReservationViewController.swift
//  Quick-Bites
//
//  Created by Kaan Turkmen on 7.01.2023.
//

import UIKit

class ReservationViewController: UIViewController {

    @IBOutlet weak var dateTimePickerTextField: UITextField!
    @IBOutlet weak var guestNumberTextField: UITextField!
    private var dataSource = ReservationDataSource()
    private var choosenStartTime: String?
    private var choosenEndTime: String?
    var restaurantId: String?
    private var isDateCorrect = false

    private lazy var dateTimePicker: DateTimePicker = {
        let picker = DateTimePicker()
        picker.setup()
        picker.didSelectDates = { [weak self] (day, startTime, endTime) in
            let startDate = Date.buildDateTimeString(day: day, time: startTime)
            let endDate = Date.buildDateTimeString(day: day, time: endTime)

            if endDate > startDate {
                self?.isDateCorrect = true
            }
            self?.choosenStartTime = startDate
            self?.choosenEndTime = endDate
            self?.dateTimePickerTextField.text = Date.buildDateTimeStringForTextField(day: day, startTime: startTime, endTime: endTime)

        }
        dateTimePickerTextField = addShadowToTextField(textField: dateTimePickerTextField)
        guestNumberTextField = addShadowToTextField(textField: guestNumberTextField)

        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Make a Reservation"
        dateTimePickerTextField.inputView = dateTimePicker.inputView
        self.hideKeyboardWhenTappedAround()

        dataSource.delegate = self
    }

    func addShadowToTextField(textField: UITextField) -> UITextField {
        textField.layer.borderWidth = 0.25
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.shadowOpacity = 1
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOffset = CGSize.zero
        textField.layer.shadowColor = UIColor.gray.cgColor
        return textField
    }

    @IBAction func confirmReservation(_ sender: Any) {
        if isDateCorrect == false {
            let alert = UIAlertController(title: "Reservation Failed", message: "Start time must be later than end time.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
            return
        }
        if
            let numGuests = guestNumberTextField.text,
            let startTime = choosenStartTime,
            let endTime = choosenEndTime,
            let restaurantId = restaurantId
        {
            dataSource.makeReservation(with: startTime, with: endTime, with: numGuests, with: restaurantId)
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

extension ReservationViewController: ReservationDataDelegate {
    func reservationConfirmed(isConfirmed: Bool) {
        let alert = UIAlertController(title: "Reservation Failed", message: "The restaurant is not available for the given time or guest number.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default)
        let okayActionWithPop = UIAlertAction(title: "Okay", style: .default) {_ in
            self.dismiss(animated: true, completion: nil)
        }

        if isConfirmed == true {
            alert.title = "Reservation Confirmed"
            alert.message = "You have successfuly made a reservation."
            alert.addAction(okayActionWithPop)
            present(alert, animated: true, completion: nil)
        } else {
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)

        }

    }

    func refreshTokenExpired() {
        PresenterManager.shared.show(nextViewController: .login)
    }

}
