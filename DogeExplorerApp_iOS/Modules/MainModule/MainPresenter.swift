//
//  MainPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

final class MainPresenterImp: MainPresenter {
    private weak var view: MainView?
    private let trackingService: AddressTrackingService
    private let networkManager: NetworkManager
    private let internetConnectionObserver: InternetConnectionObserver
    
    // MARK: - Init
    init(view: MainView, networkManager: NetworkManager, trackingService: AddressTrackingService) {
        self.view = view
        self.networkManager = networkManager
        self.trackingService = trackingService
        self.internetConnectionObserver = InternetConnectionObserverImp()
        
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
        let shortenAddress = currentAddress.address.shorten(prefix: 8, suffix: 5)
        completion(currentAddress.name, shortenAddress)
    }
    
    func searchButtonDidTap(with text: String?) {
        guard internetConnectionObserver.isReachable else {
            view?.showOkActionSheet(title: "No internet connection", message: ":/")
            return
        }
        
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
        guard internetConnectionObserver.isReachable else {
            view?.showOkActionSheet(title: "No internet connection", message: ":/")
            return
        }
        
        let selectedAddress = trackingService.getAllTrackedAddresses()[indexPath.row].address
        view?.showInfoViewController(for: selectedAddress)
    }
}
