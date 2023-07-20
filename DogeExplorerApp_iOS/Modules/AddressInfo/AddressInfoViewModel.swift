//
//  AddressInfoPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

protocol AddressInfoViewModel {
    func addTracking(name: String?)
    
    func rename(newName: String?)
    
    func deleteTracking()
    
    var numberOfLoadedTransactions: Int { get }
    
    func getViewModelForTransaction(at indexPath: IndexPath) -> Void
    
    func loadMoreTransactions()
    
    func didSelectTransaction(at indexPath: IndexPath)
}

final class AddressInfoViewModelImpl: AddressInfoViewModel {
    private let internetConnectionObserver = InternetConnectionObserver.shared
    private let networkManager: NetworkManager
    private let storageManager: StorageManager
    
    // MARK: - Address Info
    private let addressInfoModel: AddressInfoModel
    
    // MARK: - Init
    init(
        networkManager: NetworkManager,
        storageManager: StorageManager,
        model: AddressInfoModel
    ) {
        self.networkManager = networkManager
        self.storageManager = storageManager
        self.addressInfoModel = model
        
        initialize()
    }
    
    // MARK: - Protocol Methods & Properties
    func addTracking(name: String?) {
        let name = name ?? "No name"
        storageManager.addNewAddress(address: address, name: name)
        AlertKit.presentToast(message: "Successfully added to tracked addresses")
    }
    
    func rename(newName: String?) {
        guard let newName else { return }
        storageManager.renameAddress(address, newName: newName)
        AlertKit.presentToast(message: "Successfully renamed")
    }
    
    func deleteTracking() {
        storageManager.deleteAddress(address)
        AlertKit.presentToast(message: "Successfully deleted from tracked addresses")
    }
    
    
    var numberOfLoadedTransactions: Int {
        return addressInfoModel.transactions.count
    }
    
    func getViewModelForTransaction(at indexPath: IndexPath) -> Void {
        
    }
    
    func loadMoreTransactions() {
        guard internetConnectionObserver.isReachable else {
            AlertKit.presentToast(message: "No internet connection")
            return
        }
    }
    
    func didSelectTransaction(at indexPath: IndexPath) {
        
    }
}

private extension AddressInfoViewModelImpl {
    func initialize() {
        if let addressName = storageManager.getName(for: address) {
            
        } else {
            
        }
    }
    
    var address: String {
        return addressInfoModel.address
    }
}
