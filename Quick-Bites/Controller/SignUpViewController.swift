//
//  SignUpViewController.swift
//  Quick-Bites
//
//  Created by Can Usluel on 24.12.2022.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    private var dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func signup(_ sender: Any) {
        if
            let fullname = fullname.text,
            let username = username.text,
                let password = password.text,
                let email = email.text,
                let phoneNumber = phoneNumber.text
        {
            dataSource.signInUser(fullname: fullname, username: username, password: password, email: email, phoneNumber: phoneNumber)
            
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

extension SignUpViewController: DataDelegate {
    func userSignedIn() {
        _ = navigationController?.popViewController(animated: true)
    }
}
