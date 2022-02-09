//
//  SceneDelegate.swift
//  InnoFest
//
//  Created by Ryan The on 13/8/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
        
		window = UIWindow(frame: UIScreen.main.bounds)
        (UIApplication.shared.delegate as! AppDelegate).window = window
		window?.windowScene = windowScene
        
		let tabBarController = UITabBarController(nibName: nil, bundle: nil)

        let eatTab = UINavigationController(rootViewController: StallsViewController())
        eatTab.navigationBar.prefersLargeTitles = true
        
        let exploreTab = UINavigationController(rootViewController: ExploreViewController())
		
		let profileTab = UINavigationController(rootViewController: SettingsViewController(list: nil))
		
        let viewControllers = [eatTab, exploreTab, profileTab]
        let images = ["bag", "map", "person.crop.circle"]
        let titles = ["Eat", "Explore", "Profile"]
        
        tabBarController.setViewControllers(viewControllers, animated: true)
        tabBarController.selectedIndex = 1
        
		for (index, item) in tabBarController.tabBar.items!.enumerated() {
			item.image = UIImage(systemName: images[index])
			item.title = titles[index]
		}
        
        window?.tintColor = .accent
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        GIDSignIn.sharedInstance().presentingViewController = tabBarController
        
//        UserDefaults.standard.setValue(0.0, forKey: "timeSinceAppLastOpened")
        if UserDefaults.standard.double(forKey: "timeSinceAppLastOpened") == 0.0 {
            let contentView = UIView()
            
            let headerLabel = UILabel()
            contentView.addSubview(headerLabel)
            headerLabel.text = "Welcome To \(K.name)"
            headerLabel.textAlignment = .center
            headerLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            headerLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addConstraints([
                headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            ])
            
            let introViewController = ModalActionViewController(contentView: contentView, actions: [
                ModalActionAction(title: "Sign In", action: #selector(signIn), isPrimary: true),
                ModalActionAction(title: "Skip for Now", action: #selector(skipSignIn)),
            ], target: self)
            introViewController.isModalInPresentation = true
            window?.rootViewController?.present(introViewController, animated: true)
        }
	}
    
    @objc func skipSignIn() {
        let timeInterval = Date().timeIntervalSince1970
        UserDefaults.standard.setValue(timeInterval, forKey: "timeSinceAppLastOpened")
        window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc func signIn() {
        UserAuth.signIn()
    }
}
