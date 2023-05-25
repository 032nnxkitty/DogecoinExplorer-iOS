//
//  ModuleBuilder.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

final class ModuleBuilder {
    private init() {}
    
    static func createMainModule() -> UIViewController {
        let view = MainViewController()
        let networkManager = URLSessionNetworkManager.shared
        let trackingService = CoreDataManager.shared
        let presenter = MainPresenterImp(view: view, networkManager: networkManager, trackingService: trackingService)
        view.presenter = presenter
        return view
    }
    
    static func createAddressInfoModule(_ address: String) -> UIViewController {
        let view = AddressInfoViewController()
        let networkManager = URLSessionNetworkManager.shared
        let trackingService = CoreDataManager.shared
        let presenter = AddressInfoPresenterImp(address: address, view: view, networkManager: networkManager, trackingService: trackingService)
        view.presenter = presenter
        return view
    }
}
