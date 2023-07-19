//
//  SceneDelegate.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 13.04.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        UserDefaults.standard.isOnboarded = false
        
        let vc = UserDefaults.standard.isOnboarded ? Assembly.setupMainModule() : OnboardingViewController()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.overrideUserInterfaceStyle = .dark
        window?.makeKeyAndVisible()
    }
}

