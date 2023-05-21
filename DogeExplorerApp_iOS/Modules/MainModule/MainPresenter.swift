//
//  MainPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

class MainPresenterImp: MainPresenter {
    private weak var view: MainView?
    private let trackingService: AddressTrackingService
    private let networkManager: NetworkManager
    private let internetConnectionObserver: InternetConnectionObserver
    
    private var trackedAddresses: [(address: String, name: String)] {
        return trackingService.getAllTrackedAddresses()
    }
    
    // MARK: - Init
    init(view: MainView, networkManager: NetworkManager, trackingService: AddressTrackingService) {
        self.view = view
        self.networkManager = networkManager
        self.trackingService = trackingService
        self.internetConnectionObserver = InternetConnectionObserverImp()
        checkAddressesCount()
        trackingService.addMockData()
    }
    
    // MARK: - Public Methods
    func getNumberOfTrackedAddresses() -> Int {
        return trackedAddresses.count
    }
    
    func configureCell(at indexPath: IndexPath, completion: @escaping (_ name: String, _ address: String) -> Void) {
        let currentAddress = trackedAddresses[indexPath.row]
        let shortenAddress = currentAddress.address.shorten(prefix: 8, suffix: 5)
        completion(currentAddress.name, shortenAddress)
    }
    
    func searchButtonDidTap(with text: String?) {
        guard internetConnectionObserver.isReachable else {
            view?.showOkActionSheet(title: "No Internet Connection", message: "Please check your connection and try again.")
            return
        }
        
        guard let text else {
            view?.showOkActionSheet(title: "Wrong Dogecoin Address", message: "Please check the entered address and try again.")
            return
        }
        
        let address = text.trimmingCharacters(in: .whitespaces)
        guard address.count == 34 else {
            view?.showOkActionSheet(title: "Wrong Dogecoin Address", message: "Please check the entered address and try again.")
            return
        }
        
        view?.animateLoader(true)
        
        Task { @MainActor in
            guard try await networkManager.checkAddressExistence(address) else {
                view?.showOkActionSheet(title: "Address not found", message: "Please check the entered address and try again.")
                view?.animateLoader(false)
                return
            }
            view?.animateLoader(false)
            view?.showInfoViewController(for: address)
        }
    }
    
    func deleteTrackingForAddress(at indexPath: IndexPath) {
        let addressToDelete = trackedAddresses[indexPath.row].address
        trackingService.deleteTracking(addressToDelete)
        
        checkAddressesCount()
    }
    
    func renameAddress(at indexPath: IndexPath, newName: String?) {
        guard let newName else { return }
        let addressToRename = trackedAddresses[indexPath.row].address
        trackingService.renameAddress(addressToRename, to: newName)
        view?.reloadData()
    }
    
    func viewWillAppear() {
        view?.reloadData()
        checkAddressesCount()
    }
    
    func didSelectAddress(at indexPath: IndexPath) {
        guard internetConnectionObserver.isReachable else {
            view?.showOkActionSheet(title: "No Internet Connection", message: "Please check your connection and try again.")
            return
        }
        
        let selectedAddress = trackedAddresses[indexPath.row].address
        view?.showInfoViewController(for: selectedAddress)
    }
    
    func getNameForAddress(at indexPath: IndexPath) -> String? {
        return trackedAddresses[indexPath.row].name
    }
}

// MARK: - Private Methods
private extension MainPresenterImp {
    func checkAddressesCount() {
        if trackedAddresses.count == 0 {
            view?.showNoTrackedAddressesView()
        } else {
            view?.hideNoTrackedAddressesView()
        }
    }
}
