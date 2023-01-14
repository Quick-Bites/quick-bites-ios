//
//  UserInfoViewController.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 2.01.2023.
//

import UIKit

class UserInfoViewController: UIViewController {
    var username: String?
    var userReservations: [Reservation?]?
    private let userInfoDataSource = UserInfoDataSource()
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var reservationsButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Profile"
        userInfoDataSource.delegate = self
        if let username = username {
            userInfoDataSource.getUserAvatar(for: username)
            userInfoDataSource.getUserDetails()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOutTapped))
    }

    @objc func signOutTapped() {
        TokenDataSource.deleteTokens()
        PresenterManager.shared.show(vc: .login)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let reservationListController = segue.destination as? ReservationListViewController {
            reservationListController.userReservations = userReservations
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userInfoDataSource.getUserDetails()
    }
    

}

extension UserInfoViewController: UserInfoDataDelegate {
    func userAvatarLoaded(image: UIImage) {
        userImageView.image = image
    }

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
            userReservations = user.reservations
        }
    }
    
    func refreshTokenExpired() {
        PresenterManager.shared.show(vc: .login)
    }
}
