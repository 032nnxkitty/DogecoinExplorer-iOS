//
//  MainPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

protocol MainPresenter {
    init(view: MainView, networkManager: NetworkManager)
    func settingsButtonDidTap()
    
    func getNumberOfTrackedAddresses() -> Int
    func configureCell(at indexPath: IndexPath, completion: @escaping (_ name: String, _ address: String) -> Void)
    
    func searchButtonDidTap(with text: String?)
    
    func deleteTrackingForAddress(at indexPath: IndexPath)
    func renameAddress(at indexPath: IndexPath, newName: String?)
    
    func viewWillAppear()
    func getTitleFoHeader(in section: Int) -> String?
    func refresh()
    
    func didSelectAddress(at indexPath: IndexPath)
}

final class MainPresenterImp: MainPresenter {
    private weak var view: MainView?
    private let trackingService: AddressTrackingService
    private let networkManager: NetworkManager
    
    init(view: MainView, networkManager: NetworkManager) {
        self.view = view
        self.networkManager = networkManager
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
        guard let text else {
            view?.showOkActionSheet(title: "Title", message: "Something went wrong")
            return
        }
        let address = text.trimmingCharacters(in: .whitespaces)
        guard address.count == 34 else {
            view?.showOkActionSheet(title: "Title", message: "Address should contains 34 symbols")
            return
        }
        Task { @MainActor in
            guard try await networkManager.checkAddressExistence(address) else {
                view?.showOkActionSheet(title: "Address not found", message: ":(")
                return
            }
            view?.showInfoViewController(for: address)
        }
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
    
    func didSelectAddress(at indexPath: IndexPath) {
        let selectedAddress = trackingService.getAllTrackedAddresses()[indexPath.row].address
        view?.showInfoViewController(for: selectedAddress)
    }
}
