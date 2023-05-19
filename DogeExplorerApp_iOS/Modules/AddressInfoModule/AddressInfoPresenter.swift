//
//  AddressInfoPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

class AddressInfoPresenterImp: AddressInfoPresenter {
    private weak var view: AddressInfoView?
    private let networkManager: NetworkManager
    private let trackingService: AddressTrackingService
    private let internetConnectionObserver: InternetConnectionObserver
    
    // MARK: - Info About Address
    private let address: String
    private var addressInfo: (BalanceModel, TransactionsCountModel)?
    private var isAddressTracked: Bool = false
    private var loadedTransactions: [DetailedTransactionModel] = []
    
    // MARK: - Init
    init(address: String, view: AddressInfoView, networkManager: NetworkManager, trackingService: AddressTrackingService) {
        self.view = view
        self.networkManager = networkManager
        self.trackingService = trackingService
        self.internetConnectionObserver = InternetConnectionObserverImp()
        
        self.address = address
        
        configureTrackingState()
        getBaseAddressInfo()
    }
    
    // MARK: - Table View Configuring Methods
    func getNumberOfTransactions() -> Int {
        return loadedTransactions.count
    }
    
    func configureTransactionCell(at indexPath: IndexPath, completion: @escaping (_ style: TransactionStyle, _ value: String, _ time: String, _ hash: String) -> Void) {
        guard indexPath.row < loadedTransactions.count else { return }
        let currentTransaction = loadedTransactions[indexPath.row].transaction
        
        let time = currentTransaction.time.formatUnixTime()
        let hash = currentTransaction.hash.shorten(prefix: 6, suffix: 6)
        
        var balanceChange: Double = 0.0
        
        for input in currentTransaction.inputs {
            if input.address == self.address {
                let value = Double(input.value) ?? 0
                balanceChange -= value
            }
        }
        
        for output in currentTransaction.outputs {
            if output.address == self.address {
                let value = Double(output.value) ?? 0
                balanceChange += value
            }
        }
        
        let formattedBalanceChange = String(abs(balanceChange)).formatNumberString()
        
        if balanceChange >= 0 {
            completion(.received, "+\(formattedBalanceChange) DOGE", time, hash)
        } else {
            completion(.sent, "-\(formattedBalanceChange) DOGE", time, hash)
        }
    }
    
    // MARK: - Tracking Methods
    func trackingStateDidChange() {
        if isAddressTracked {
            trackingService.deleteTracking(address)
            configureTrackingState()
        } else {
            guard trackingService.getAllTrackedAddresses().count < 10 else {
                view?.showOkActionSheet(title: "You can track only 10 addresses", message: ":/")
                return
            }
            view?.showAddTrackingAlert()
        }
    }
    
    func addTracking(with name: String?) {
        guard let name, !name.isEmpty else {
            trackingService.addNewTrackedAddress(address: address, name: "No name")
            configureTrackingState()
            return
        }
        trackingService.addNewTrackedAddress(address: address, name: name)
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
            view?.showOkActionSheet(title: ":/", message: "No internet connection")
            return
        }
        
        guard let allTransactionsCount = addressInfo?.1.info.total else { return }
        let difference = allTransactionsCount - loadedTransactions.count
        guard difference > 0 else { return }
        
        view?.animateLoadTransactionLoader(true)
        Task { @MainActor in
            do {
                let start = Date()
                
                let pageToLoad = (loadedTransactions.count / 10) + 1
                try await loadTransactionsPage(pageToLoad)
                if difference <= 10 { view?.hideLoadTransactionsButton() }
                
                view?.reloadData()
                view?.makeHapticFeedback()
                
                print("full transaction page loading time: \(Date().timeIntervalSince(start))")
            } catch {
                print(error, #function)
            }
            view?.animateLoadTransactionLoader(false)
        }
    }
    
    func didSelectTransaction(at indexPath: IndexPath) {
        print("transaction tapped")
    }
    
    func getAddressName() -> String? {
        return trackingService.getTrackingName(for: address)
    }
}

// MARK: - Private Methods
private extension AddressInfoPresenterImp {
    func configureTrackingState() {
        if let name = trackingService.getTrackingName(for: address) {
            isAddressTracked = true
            view?.configureIfAddressTracked(name: name)
        } else {
            isAddressTracked = false
            view?.configureIfAddressNotTracked(shortenAddress: address.shorten(prefix: 5, suffix: 4))
        }
    }
    
    func getBaseAddressInfo() {
        view?.animateCentralLoader(true)
        Task { @MainActor in
            do {
                let start = Date()
                
                async let info = networkManager.getAddressInfo(address)
                try await loadTransactionsPage(1)
                addressInfo = try await info
                
                if addressInfo!.1.info.total <= 10 { view?.hideLoadTransactionsButton() }
                view?.setAddressInfo(address: address,
                                     dogeBalance: "\(addressInfo!.0.balance.formatNumberString()) DOGE",
                                     transactionsCount: "\(addressInfo!.1.info.total)")
                
                
                print("base info loading time: \(Date().timeIntervalSince(start))")
            } catch {
                view?.showOkActionSheet(title: ":/", message: error.localizedDescription)
            }
            view?.animateCentralLoader(false)
        }
    }
    
    func loadTransactionsPage(_ page: Int) async throws {
        let newTransactions = try await networkManager.getDetailedTransactionsPage(for: address, page: page)
        loadedTransactions += newTransactions
        loadedTransactions.sort { $0.transaction.time > $1.transaction.time }
    }
}
