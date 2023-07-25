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
    private var addressInfoModel: AddressInfoModel
    
    // MARK: - Init
    init(
        networkManager: NetworkManager,
        storageManager: StorageManager,
        model: AddressInfoModel
    ) {
        self.networkManager = networkManager
        self.storageManager = storageManager
        self.addressInfoModel = model
    }
    
    // MARK: - Protocol Methods & Properties
    var observableViewState: Observable<AddressInfoViewState> = .init(value: .initial)
    
    func viewDidLoad() {
        sortLoadedTransactions()
        
        if let name = storageManager.getName(for: address) {
            observableViewState.value = .becomeTracked(name: name)
        } else {
            observableViewState.value = .becomeUntracked
        }
        
        if addressInfoModel.transactionsCountModel.info.total <= 10 {
            observableViewState.value = .allTransactionsLoaded
        }
    }
    
    var address: String {
        return addressInfoModel.address
    }
    
    var formattedBalance: String {
        return addressInfoModel.balanceModel.balance.formatNumberString()
    }
    
    var totalTransactionsCount: String {
        return "\(addressInfoModel.transactionsCountModel.info.total)"
    }
    
    func startTracking(name: String?) {
        guard var name else { return }
        if name.isEmpty {
            name = "No name"
        }

        storageManager.addNewAddress(address: address, name: name)
        
        observableViewState.value = .becomeTracked(name: name)
        observableViewState.value = .message(text: "The address was successfully added to the tracked")
    }
    
    func rename(newName: String?) {
        guard let newName, !newName.isEmpty else { return }
        storageManager.renameAddress(address, newName: newName)
        
        observableViewState.value = .becomeTracked(name: newName)
        observableViewState.value = .message(text: "The address was successfully renamed")
    }
    
    
    var numberOfLoadedTransactions: Int {
        return addressInfoModel.loadedTransactions.count
    }
    
    func getViewModelForTransaction(at indexPath: IndexPath) -> TransactionCellViewModel {
        let currentTransaction = addressInfoModel.loadedTransactions[indexPath.row].transaction
        
        let date = currentTransaction.time?.formatUnixTime(style: .shorten) ?? "01.01.0001"
        let hash = currentTransaction.hash?.shorten(prefix: 6, suffix: 6) ?? "hash"
        
        var balanceChange: Double = 0.0
        
        for input in currentTransaction.inputs ?? [] {
            guard input.address == self.address else { continue }
            if let value = input.value {
                balanceChange -= Double(value) ?? 0
            }
        }
        
        for output in currentTransaction.outputs ?? [] {
            guard output.address == self.address else { continue }
            if let value = output.value {
                balanceChange += Double(value) ?? 0
            }
        }
        
        let formattedBalanceChange = String(abs(balanceChange)).formatNumberString()
        
        if balanceChange >= 0 {
            return .init(style: .received, value: "+\(formattedBalanceChange)", date: date, hash: hash)
        } else {
            return .init(style: .sent, value: "-\(formattedBalanceChange)", date: date, hash: hash)
        }
    }
    
    func loadMoreTransactionsButtonDidTap() {
        guard internetConnectionObserver.isReachable else {
            observableViewState.value = .message(text: "No internet connection")
            return
        }
        
        let allTransactionsCount = addressInfoModel.transactionsCountModel.info.total
        let difference = allTransactionsCount - addressInfoModel.loadedTransactions.count
        
        observableViewState.value = .startLoadTransactions
        
        Task { @MainActor in
            defer {
                observableViewState.value = .finishLoadTransactions
            }
            
            let pageToLoad = (addressInfoModel.loadedTransactions.count / 10) + 1
            do {
                let newTransactions = try await networkManager.loadDetailedTransactionsPage(for: address, page: pageToLoad)
                addressInfoModel.loadedTransactions.append(contentsOf: newTransactions)
                sortLoadedTransactions()
                if difference <= 10 {
                    observableViewState.value = .allTransactionsLoaded
                    observableViewState.value = .message(text: "All transactions are loaded")
                }
            } catch let error as NetworkError {
                observableViewState.value = .message(text: error.localizedDescription)
            } catch _ {
                observableViewState.value = .message(text: "Something went wrong :/")
            }
        }
    }
    
    func trackingButtonDidTap() {
        if storageManager.trackedAddresses.contains(where: { $0.address == address }) {
            storageManager.deleteAddress(address)
            observableViewState.value = .becomeUntracked
            observableViewState.value = .message(text: "The address was successfully deleted")
        } else {
            observableViewState.value = .startTrackAlert
        }
    }
    
    func renameButtonDidTap() {
        let oldName = storageManager.getName(for: address)
        observableViewState.value = .renameAlert(oldName: oldName)
    }
    
    func didSelectTransaction(at indexPath: IndexPath) {
        let selectedTransaction = addressInfoModel.loadedTransactions[indexPath.row]
        observableViewState.value = .push(model: selectedTransaction)
    }
}

// MARK: - Private Methods & Properties
private extension AddressInfoViewModelImpl {
    func sortLoadedTransactions() {
        addressInfoModel.loadedTransactions.sort { $0.transaction.time ?? 0 >= $1.transaction.time ?? 0 }
    }
}
