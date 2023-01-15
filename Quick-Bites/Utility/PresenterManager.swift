//
//  PresenterManager.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 14.01.2023.
//

import UIKit

class PresenterManager {
    static let shared = PresenterManager()
    private init() {}

    enum ViewControllerEnum {
        case login
        case location
        case authorize
        case category
    }

    func show(nextViewController: ViewControllerEnum) {
        var viewController: UIViewController
        switch nextViewController {
        case .login:
            viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNavigationController")
        case .authorize:
            viewController = UIStoryboard(name: "Location", bundle: nil).instantiateViewController(withIdentifier: "LocationPrepareViewController")
        case .location:
            viewController = UIStoryboard(name: "Location", bundle: nil).instantiateViewController(withIdentifier: "LocationViewController")
        case .category:
            viewController = UIStoryboard(name: "CategorySelection", bundle: nil).instantiateViewController(withIdentifier: "CategoryNavigationViewController")
        }

        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = viewController
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}
