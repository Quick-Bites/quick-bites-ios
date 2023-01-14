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
    }
    
    func show(vc: ViewControllerEnum) {
        var viewController: UIViewController
        switch vc {
        case .login:
            viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNavigationController")
        case .location:
            viewController = UIStoryboard(name: "CitySelection", bundle: nil).instantiateViewController(withIdentifier: "LocationNavigationViewController")
        }
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = viewController
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion:nil)
        }
    }
}
