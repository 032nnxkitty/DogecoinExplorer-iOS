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
    
    func searchButtonDidTap(with text: String?)
    
    func deleteTrackingForAddress(at indexPath: IndexPath)
    func renameAddress(at indexPath: IndexPath, newName: String?)
    
    func viewWillAppear()
    func getTitleFoHeader(in section: Int) -> String?
    func refresh()
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
    
    func searchButtonDidTap(with text: String?) {
        
    }
    
    func deleteTrackingForAddress(at indexPath: IndexPath) {
        let addressToDelete = trackingService.getAllTrackedAddresses()[indexPath.row].address
        trackingService.deleteTracking(addressToDelete)
        //view?.reloadData()
    }
    
    func renameAddress(at indexPath: IndexPath, newName: String?) {
        guard let newName else { return }
        let addressToRename = trackingService.getAllTrackedAddresses()[indexPath.row].address
        trackingService.renameAddress(addressToRename, to: newName)
        view?.reloadData()
    }
    
    func viewWillAppear() {
        view?.reloadData()
    }
    
    func getTitleFoHeader(in section: Int) -> String? {
        return section == 0 ? "Tracked addresses:" : nil
    }
    
    func refresh() {
        
    }
}
