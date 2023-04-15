//
//  MainPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

protocol MainPresenter {
    init(view: MainView)
    func settingsButtonDidTap()
    
    func getNumberOfTrackedAddresses() -> Int
    func configureCell(at indexPath: IndexPath, completion: @escaping (_ name: String, _ address: String) -> Void)
}

final class MainPresenterImp: MainPresenter {
    private weak var view: MainView?
    private let trackingService: AddressTrackingService
    
    init(view: MainView) {
        self.view = view
        self.trackingService = UserDefaults.standard
        
        trackingService.addMockData()
    }
    
    // MARK: - Public Methods
    func settingsButtonDidTap() {
        view?.showSettingsViewController()
    }
    
    func getNumberOfTrackedAddresses() -> Int {
        return trackingService.getAllTrackedAddresses().count
    }
    
    func configureCell(at indexPath: IndexPath, completion: @escaping (_ name: String, _ address: String) -> Void) {
        let currentAddress = trackingService.getAllTrackedAddresses()[indexPath.row]
        let shortenAddress = currentAddress.address.shortenAddress()
        completion(currentAddress.name, shortenAddress)
    }
}
