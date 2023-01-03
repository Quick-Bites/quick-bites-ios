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
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var reservationsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Profile"
        userInfoDataSource.delegate = self
        if let username = username {
            userInfoDataSource.getUserDetails(for: username)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Sign Out", style: .done, target: self, action: #selector(signOutTapped))
      
    }
    
    @objc func signOutTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernameLabel.text = "N/A"
        fullNameLabel.text = "N/A"
        emailLabel.text = "N/A"
        phoneLabel.text = "N/A"
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
        usernameLabel.text = user.username
        fullNameLabel.text = user.name
        emailLabel.text = user.email
        phoneLabel.text = user.phoneNumber
        if user.reservations.isEmpty {
            reservationsButton.isEnabled = false
            reservationsButton.alpha = 0.9
            reservationsButton.tintColor = .gray
            reservationsButton.setTitle("No reservations were found", for: .normal)
        } else {
            reservationsButton.isEnabled = true
            reservationsButton.alpha = 1
            reservationsButton.tintColor = .blue
        }
    }
}
