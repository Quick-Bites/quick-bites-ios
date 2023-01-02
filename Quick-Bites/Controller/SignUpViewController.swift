//
//  SignUpViewController.swift
//  Quick-Bites
//
//  Created by Can Usluel on 24.12.2022.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    private var dataSource = AuthenticationDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func signup(_ sender: Any) {
        if
            let fullname = fullNameTextField.text,
            let username = usernameTextField.text,
                let password = passwordTextField.text,
                let email = emailTextField.text,
                let phoneNumber = phoneNumberTextField.text
        {
            dataSource.signUpUser(fullname: fullname, username: username, password: password, email: email, phoneNumber: phoneNumber)
            
        }else{
            print("error")
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

extension SignUpViewController: AuthenticationDataDelegate {
    func userSignedUp() {
        _ = navigationController?.popViewController(animated: true)
    }
}
