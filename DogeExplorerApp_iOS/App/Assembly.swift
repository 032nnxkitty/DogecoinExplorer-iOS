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
        let networkManager = URLSessionNetworkManager.shared
        let storageMananger = CoreDataStorageManager.shared
        
        let viewModel = AddressInfoViewModelImpl(networkManager: networkManager, storageManager: storageMananger)
        let view = AddressInfoViewController(viewModel: viewModel)
        
        return view
    }
}
