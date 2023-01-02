//
//  UserInfoViewController.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 2.01.2023.
//

import UIKit

class UserInfoViewController: UIViewController {
    var username: String?
    private let userInfoDataSource = UserInfoDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userInfoDataSource.delegate = self
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

extension UserInfoViewController: UserInfoDataDelegate {
    func userInfoLoaded(user: User) {

    }
}
