//
//  AddressInfoPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

final class AddressInfoPresenterImpl: AddressInfoPresenter {
    // MARK: - Private Properties
    private weak var view: AddressInfoView?
    
    private let internetConnectionObserver = InternetConnectionObserverImpl.shared
    private let trackingService: AddressTrackingService
    private let networkManager: NetworkManager
    
    // MARK: Info About Address
    private let address: String
    private var isAddressTracked: Bool = false
    private var addressInfo: (BalanceModel, TransactionsCountModel)
    private var loadedTransactions: [DetailedTransactionModel] = []
    
    // MARK: - Init
    init(
        address: String,
        addressInfo: (BalanceModel, TransactionsCountModel),
        view: AddressInfoView,
        networkManager: NetworkManager,
        trackingService: AddressTrackingService
    ) {
        self.view = view
        self.networkManager = networkManager
        self.trackingService = trackingService
        
        self.address = address
        self.addressInfo = addressInfo
        
        initialize()
        configureTrackingState()
    }
    
    // MARK: - Table View Configuring Methods
    func getNumberOfLoadedTransactions() -> Int {
        return loadedTransactions.count
    }
    
    func configureTransactionCell(at indexPath: IndexPath) -> (style: TransactionStyle, value: String, time: String, hash: String) {
        let currentTransaction = loadedTransactions[indexPath.row].transaction
        
        var balanceChange: Double = 0.0
        
        currentTransaction.inputs.forEach { input in
            guard input.address == address else { return }
            let value = Double(input.value) ?? 0
            balanceChange -= value
        }
        
        currentTransaction.outputs.forEach { output in
            guard output.address == address else { return }
            let value = Double(output.value) ?? 0
            balanceChange += value
            
        }
        
        let formattedBalanceChange = String(abs(balanceChange)).formatNumberString()
        
        let style: TransactionStyle = balanceChange >= 0 ? .received : .sent
        let formattedTime = currentTransaction.time.formatUnixTime()
        let formattedHash = currentTransaction.hash.shorten(prefix: 6, suffix: 6)
        let formattedValue = "\(balanceChange >= 0 ? "+" : "-")\(formattedBalanceChange) DOGE"
        
        return (style, formattedValue, formattedTime, formattedHash)
    }
    
    // MARK: - Tracking Methods
    func trackingStateDidChange() {
        if isAddressTracked {
            trackingService.deleteTracking(address)
            configureTrackingState()
        } else {
            guard trackingService.getAllTrackedAddresses().count < 10 else {
                view?.showOkActionSheet(title: "Limit", message: "You can track only 10 addresses.")
                return
            }
            view?.showAddTrackingAlert()
        }
    }
    
    func addTracking(with name: String?) {
        trackingService.addNewTrackedAddress(address: address, name: name ?? "No name")
        configureTrackingState()
    }
    
    func renameButtonDidTap() {
        view?.showRenameAlert()
    }
    
    func renameAddress(newName: String?) {
        guard let newName, !newName.isEmpty else { return }
        trackingService.renameAddress(address, to: newName)
        configureTrackingState()
    }
    
    // MARK: - Load Transactions Methods
    func loadTransactionsButtonDidTap() {
        guard internetConnectionObserver.isReachable else {
            view?.showOkActionSheet(title: "No Internet Connection", message: "Please check your connection and try again.")
            return
        }
        
        let allTransactionsCount = addressInfo.1.info.total
        let difference = allTransactionsCount - loadedTransactions.count
        guard difference > 0 else { return }
        
        view?.animateLoadTransactionLoader(true)
        Task { @MainActor in
            do {
                let pageToLoad = (loadedTransactions.count / 10) + 1
                
                try await loadTransactionsPage(pageToLoad)
                
                view?.reloadData()
                view?.makeHapticFeedback()
                
                if difference <= 10 {
                    view?.hideLoadTransactionsButton()
                }
            } catch {
                view?.showOkActionSheet(title: "Something went wrong", message: "Please try again later")
            }
            view?.animateLoadTransactionLoader(false)
        }
    }
    
    func didSelectTransaction(at indexPath: IndexPath) {
        // ..
    }
    
    func getAddressName() -> String? {
        return trackingService.getTrackingName(for: address)
    }
}

// MARK: - Private Methods
private extension AddressInfoPresenterImpl {
    func configureTrackingState() {
        if let name = trackingService.getTrackingName(for: address) {
            isAddressTracked = true
            view?.configureIfAddressTracked(name: name)
        } else {
            isAddressTracked = false
            view?.configureIfAddressNotTracked(shortenAddress: address.shorten(prefix: 5, suffix: 4))
        }
    }
    
    func initialize() {
        view?.animateCentralLoader(true)
        Task { @MainActor in
            do {
                try await loadTransactionsPage(1)
                
                view?.setAddressInfo(address: address,
                                     dogeBalance: "\(addressInfo.0.balance.formatNumberString()) DOGE",
                                     transactionsCount: "\(addressInfo.1.info.total)")
                
                if addressInfo.1.info.total <= 10 {
                    view?.hideLoadTransactionsButton()
                }
            } catch {
                view?.showOkActionSheet(title: "Something went wrong", message: "Please try again later")
            }
            view?.animateCentralLoader(false)
        }
    }
    
    func loadTransactionsPage(_ page: Int) async throws {
        let newTransactions = try await networkManager.loadDetailedTransactionsPage(for: address, page: page)
        loadedTransactions += newTransactions
        loadedTransactions.sort { $0.transaction.time > $1.transaction.time }
    }
}
