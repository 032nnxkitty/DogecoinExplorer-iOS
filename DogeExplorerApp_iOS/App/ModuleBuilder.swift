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
        let presenter = MainPresenterImpl(view: view, networkManager: networkManager, trackingService: trackingService)
        view.presenter = presenter
        return view
    }
    
    static func createAddressInfoModule(
        address: String,
        addressInfo: (BalanceModel, TransactionsCountModel)
    ) -> UIViewController {
        
        let view = AddressInfoViewController()
        let networkManager = URLSessionNetworkManager.shared
        let trackingService = CoreDataManager.shared
        let presenter = AddressInfoPresenterImpl(address: address,
                                                 addressInfo: addressInfo,
                                                 view: view,
                                                 networkManager: networkManager,
                                                 trackingService: trackingService)
        view.presenter = presenter
        return view
    }
}
