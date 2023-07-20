//
//  AddressInfoViewModelImpl.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

final class AddressInfoViewModelImpl: AddressInfoViewModel {
    private let internetConnectionObserver = InternetConnectionObserver.shared
    private let networkManager: NetworkManager
    private let storageManager: StorageManager
    
    // MARK: - Address Info
    private let addressInfoModel: AddressInfoModel
    private var isTracked: Bool = false
    
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
    var observableViewState: Observable<AddressInfoViewState> = .init(value: .initial)
    
    var address: String {
        return addressInfoModel.address
    }
    
    var formattedBalance: String {
        return "\(addressInfoModel.balanceModel.balance.formatNumberString()) DOGE"
    }
    
    var totalTransactionsCount: String {
        return "\(addressInfoModel.transactionsCountModel.info.total)"
    }
    
    func startTracking(name: String?) {
        let name = name ?? "No name"
        storageManager.addNewAddress(address: address, name: name)
        
        observableViewState.value = .becomeTracked(name: name)
    }
    
    func rename(newName: String?) {
        guard let newName else { return }
        storageManager.renameAddress(address, newName: newName)
        
        observableViewState.value = .becomeTracked(name: newName)
    }
    
    
    var loadedTransactions: [Int] {
        return addressInfoModel.transactions.compactMap { $0.success }
    }
    
    func loadMoreTransactionsButtonDidTap() {
        guard internetConnectionObserver.isReachable else {
            // ..
            return
        }
        
        guard false else { return }
        
        Task { @MainActor in
            let pageToLoad = (loadedTransactions.count / 10) + 1
            let newTransactions = try await networkManager.loadDetailedTransactionsPage(for: address, page: pageToLoad)
        }
    }
    
    func trackingButtonDidTap() {
        if isTracked {
            storageManager.deleteAddress(address)
            observableViewState.value = .becomeUntracked
        } else {
            observableViewState.value = .startTrackAlert
        }
    }
    
    func renameButtonDidTap() {
        observableViewState.value = .renameAlert(oldName: "Old name")
    }
    
    func didSelectTransaction(at indexPath: IndexPath) {
        
    }
}

// MARK: - Private Methods
private extension AddressInfoViewModelImpl {
    func initialize() {
        
    }
}
