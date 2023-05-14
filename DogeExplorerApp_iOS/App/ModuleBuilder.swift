//
//  ModuleBuilder.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

class ModuleBuilder {
    private init() {}
    
    class func createMainModule() -> UIViewController {
        let view = MainViewController()
        let networkManager = NetworkManagerImp()
        let trackingService = CoreDataManager.shared
        let presenter = MainPresenterImp(view: view, networkManager: networkManager, trackingService: trackingService)
        view.presenter = presenter
        return view
    }
    
    class func createAddressInfoModule(_ address: String) -> UIViewController {
        let view = AddressInfoViewController()
        let networkManager = NetworkManagerImp()
        let trackingService = CoreDataManager.shared
        let presenter = AddressInfoPresenterImp(address: address, view: view, networkManager: networkManager, trackingService: trackingService)
        view.presenter = presenter
        return view
    }
}
