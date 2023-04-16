//
//  ModuleBuilder.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

final class ModuleBuilder {
    static func createMainModule() -> UIViewController {
        let view = MainViewController()
        let networkManager = NetworkManagerImp()
        let presenter = MainPresenterImp(view: view, networkManager: networkManager)
        view.presenter = presenter
        return view
    }
    
    static func createSettingsModule() -> UIViewController {
        let view = SettingsViewController()
        let presenter = SettingsPresenterImp(view: view)
        view.presenter = presenter
        return view
    }
    
    static func createAddressInfoModule(_ address: String) -> UIViewController {
        let view = AddressInfoViewController()
        let networkManager = NetworkManagerImp()
        let presenter = AddressInfoPresenterImp(address: address, view: view, networkManager: networkManager)
        view.presenter = presenter
        return view
    }
}
