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

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    private var username: String?
    
    private var dataSource = AuthenticationDataSource()

    func UIColorFromRGB(_ rgbValue: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0x00FF00) >> 8))/255.0, blue: ((CGFloat)((rgbValue & 0x0000FF)))/255.0, alpha: 1.0)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [UIColorFromRGB(0x2B95CE).cgColor, UIColorFromRGB(0x2ECAD5).cgColor]
                gradientLayer.frame = view.bounds
                let animation = CABasicAnimation(keyPath: "startPoint")
                animation.fromValue = CGPoint(x: 0, y: 0.5)
                animation.toValue = CGPoint(x: 1, y: 0.5)
                animation.duration = 5.0
                animation.repeatCount = Float.infinity
                animation.autoreverses = true
                animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                gradientLayer.add(animation, forKey: "startPoint")
                view.layer.addSublayer(gradientLayer)
                gradientLayer.zPosition = -1
        gradientLayer.frame = view.layer.bounds
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        
        // Do any additional setup after loading the view.
        loginButton.tintColor = UIColorFromRGB(0x333333)
        signUpButton.tintColor = UIColorFromRGB(0x333333)
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

