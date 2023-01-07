//
//  ViewController.swift
//  Quick-Bites
//
//  Created by Can Usluel on 24.12.2022.
//

import UIKit

class LoginViewController: UIViewController {


    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private var username: String?

    private var dataSource = AuthenticationDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if
            let locationViewController = segue.destination as? LocationViewController,
            let username = self.username
        {
            locationViewController.username = username
            usernameTextField.text=""
            passwordTextField.text=""
        }
    }

    @IBAction func login(_ sender: Any) {
        if
            let username = usernameTextField.text,
            let password = passwordTextField.text
        {
            dataSource.logInUser(username: username, password: password)
        } else {
            print("error")
        }

    }
}

extension LoginViewController: AuthenticationDataDelegate {
    func userLoggedIn(username: String) {
        self.username = username
        performSegue(withIdentifier: "showCitySelection", sender: self)
    }
}

