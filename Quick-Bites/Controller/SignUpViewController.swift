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
    @IBOutlet weak var addressTextField: UITextField!
    
    private var dataSource = AuthenticationDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        // Do any additional setup after loading the view.
        self.title = "Sign Up"
    }


    @IBAction func signup(_ sender: Any) {
        if
            let fullname = fullNameTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            let email = emailTextField.text,
            let phoneNumber = phoneNumberTextField.text,
            let address = addressTextField.text
        {
            if fullname.isEmpty || username.isEmpty || password.isEmpty || email.isEmpty || phoneNumber.isEmpty || address.isEmpty {
                displaySignUpAlert(title: "Sign Up Failed", message: "All fields must be filled.")
                return
            }
            dataSource.signUpUser(fullname: fullname, username: username, password: password, email: email, phoneNumber: phoneNumber, address: address)

        } else {
            displaySignUpAlert(title: "Sign Up Failed", message: "Sign Up proccess has been failed.")
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
    func displaySignUpAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }

}

extension SignUpViewController: AuthenticationDataDelegate {
    func userSignedUp() {
        let alert = UIAlertController(title: "Sign Up Successful", message: "You have successfuly signed up to our system.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) {_ in
            _ = self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
}
