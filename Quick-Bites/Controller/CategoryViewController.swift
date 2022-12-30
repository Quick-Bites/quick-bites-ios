//
//  CategoryViewController.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 30.12.2022.
//

import UIKit

class CategoryViewController: UIViewController {

    var cityName: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let cityName = cityName {
            self.title = cityName
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
