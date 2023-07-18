//
//  ModuleBuilder.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

final class Assembly {
    private init() {}
    
    static func setupMainModule() -> UIViewController {
        let networkManager = URLSessionNetworkManager.shared
        let storageManager = CoreDataStorageManager.shared
        
        let viewModel = MainViewModelImpl(networkManager: networkManager, storageManager: storageManager)
        let view = MainViewController(viewModel: viewModel)
       
        return view
    }
    
    static func setupAddressInfoModule(address: String) -> UIViewController {
        let view = AddressInfoViewController()
        let networkManager = URLSessionNetworkManager.shared
        let trackingService = CoreDataStorageManager.shared
        
        return view
    }
}
