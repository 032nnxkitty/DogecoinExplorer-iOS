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
        window = UIWindow(windowScene: windowScene)
        window?.overrideUserInterfaceStyle = .dark
        window?.rootViewController = UINavigationController(rootViewController: ModuleBuilder.createMainModule())
        window?.makeKeyAndVisible()
    }
}

