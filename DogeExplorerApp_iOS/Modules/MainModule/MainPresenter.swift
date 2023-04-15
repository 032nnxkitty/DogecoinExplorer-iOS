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
}
