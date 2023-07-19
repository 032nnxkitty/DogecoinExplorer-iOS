//
//  AddressInfoPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

protocol AddressInfoViewModel {
    var numberOfLoadedTransactions: Int { get }
    
    var isTracked: Bool { get }
    
    func addTracking(name: String?)
    
    func deleteTracking()
    
    func rename(newName: String?)
    
    func getViewModelForTransaction(at indexPath: IndexPath) -> Void
    
    func loadMoreTransactions()
    
    func didSelectTransaction(at indexPath: IndexPath)
}

final class AddressInfoViewModelImpl: AddressInfoViewModel {
    private let internetConnectionObserver = InternetConnectionObserver.shared
    private let networkManager: NetworkManager
    private let storageManager: StorageManager
    
    // MARK: - Address Info
    private var address: String
    private var balanceModel: BalanceModel
    private var transactionCountModel: TransactionsCountModel
    private var loadedTransactions: [TransactionInfoModel] = []
    
    // MARK: - Init
    init(
        networkManager: NetworkManager,
        storageManager: StorageManager,
        model: Assembly.AddressInfoSetupModel
    ) {
        self.networkManager = networkManager
        self.storageManager = storageManager
        
        self.address = model.address
        self.balanceModel = model.balanceModel
        self.transactionCountModel = model.transactionsCountModel
        initialize()
    }
    
    // MARK: - Protocol Methods & Properties
    var numberOfLoadedTransactions: Int {
        return loadedTransactions.count
    }
    
    var isTracked: Bool = false
    
    func addTracking(name: String?) {
        storageManager.addNewAddress(address: address, name: name ?? "No name")
        AlertKit.presentToast(message: "Successfully added to tracked addresses")
    }
    
    func deleteTracking() {
        storageManager.deleteAddress(address)
        AlertKit.presentToast(message: "Successfully deleted from tracked addresses")
    }
    
    func rename(newName: String?) {
        guard let newName else { return }
        storageManager.renameAddress(address, newName: newName)
        AlertKit.presentToast(message: "Successfully renamed")
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
}
