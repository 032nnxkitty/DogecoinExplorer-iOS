//
//  MainViewModel.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

final class MainViewModelImpl: MainViewModel {
    // MARK: - Services
    private let internetConnectionObserver = InternetConnectionObserverImpl.shared
    private let trackingService: AddressTrackingService
    private let networkManager: NetworkManager
    
    // MARK: - Init
    init(networkManager: NetworkManager,trackingService: AddressTrackingService) {
        self.networkManager = networkManager
        self.trackingService = trackingService
    }
    
    // MARK: - Protocol
    var observableErrorMessage: ObservableObject<(title: String, message: String)> = .init(value: ("",""))
    
    var a = 9
    var numberOfTrackedAddresses: Int {
        return a
    }
    
    func getViewModelForAddress(at indexPath: IndexPath) -> TrackedAddressCellViewModel {
        return .init(name: "a", address: "a")
    }
    
    func deleteAddress(at indexPath: IndexPath) {
        a -= 1
    }
    
    func addTracking(address: String, name: String) {
        
    }
    
    func renameAddress(at indexPath: IndexPath, newName: String) {
        
    }
    
    func searchButtonDidTap(text: String?) {
        guard internetConnectionObserver.isReachable else {
            observableErrorMessage.value = (title: "No Internet Connection", message: "Please check your connection and try again.")
            return
        }
        
        guard let text else {
            observableErrorMessage.value = (title: "Wrong Dogecoin Address", message: "Please check the entered address and try again.")
            return
        }
        
        let address = text.trimmingCharacters(in: .whitespaces)
        guard address.count == 34 else {
            observableErrorMessage.value = (title: "Wrong Dogecoin Address", message: "Please check the entered address and try again.")
            return
        }
        
        // load info
    }
}

// MARK: - Private Methods
private extension MainViewModelImpl {
    
}
