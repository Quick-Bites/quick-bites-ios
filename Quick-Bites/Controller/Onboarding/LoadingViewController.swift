//
//  LoadingViewController.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 14.01.2023.
//

import UIKit

class LoadingViewController: UIViewController {
    private var userInfoDataSource = UserInfoDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userInfoDataSource.delegate = self
        userInfoDataSource.getUserDetails()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func showInitialScreen() {
        
    }
}

extension LoadingViewController: UserInfoDataDelegate {
    func refreshTokenExpired() {
        print("Refresh token expired")
        PresenterManager.shared.show(vc: .login)
    }
    func userLoggedIn() {
        print("Refresh token not expired")
        PresenterManager.shared.show(vc: .authorize)
    }
}


