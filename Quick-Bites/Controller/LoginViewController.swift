//
//  ViewController.swift
//  Quick-Bites
//
//  Created by Can Usluel on 24.12.2022.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    private var dataSource = AuthenticationDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        if
            let username = username.text,
            let password = password.text
        {
            dataSource.logInUser(username: username, password: password)
            
        }else{
            print("error")
        }
        
    }
}

extension LoginViewController: AuthenticationDataDelegate {
    func userLoggedIn() {
        performSegue(withIdentifier: "showCitySelection", sender: self)
    }
}

