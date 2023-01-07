//
//  ReservationViewController.swift
//  Quick-Bites
//
//  Created by Kaan Turkmen on 7.01.2023.
//

import UIKit

class ReservationViewController: UIViewController {

    @IBOutlet weak var dateTimePickerTextField: UITextField!

    private lazy var dateTimePicker: DateTimePicker = {
        let picker = DateTimePicker()
        picker.setup()
        picker.didSelectDates = { [weak self] (day, startTime, endTime) in
            let startDate = Date.buildDateTimeString(day: day, time: startTime)
            let endDate = Date.buildDateTimeString(day: day, time: endTime)
            
            print("Start Date: \(startDate)")
            print("End Date: \(endDate)")
        }
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dateTimePickerTextField.inputView = dateTimePicker.inputView
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
