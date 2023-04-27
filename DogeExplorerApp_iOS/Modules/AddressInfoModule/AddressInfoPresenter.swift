//
//  AddressInfoPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

enum ShowingSection: Int {
    case info
    case transactions
}

protocol AddressInfoPresenter: AddressInfoEventHandling, AddressInfoActions{
    init(address: String, view: AddressInfoView, networkManager: NetworkManager, trackingService: AddressTrackingService)
    func getNumberOfTransactions() -> Int
}

protocol AddressInfoEventHandling {
    func trackingStateDidChange()
    func renameButtonDidTap()
    func loadTransactionsButtonDidTap()
    func didSelectTransaction(at indexPath: IndexPath)
}

protocol AddressInfoActions {
    func configureTransactionCell(at indexPath: IndexPath, completion: @escaping (_ style: TransactionStyle, _ value: String, _ time: String, _ hash: String) -> Void)
    
    func addTracking(with name: String?)
    func renameAddress(newName: String?)
    func deleteTracking()
}

final class AddressInfoPresenterImp: AddressInfoPresenter {
    private weak var view: AddressInfoView?
    private let networkManager: NetworkManager
    private let trackingService: AddressTrackingService
    
    private let address: String
    private var isAddressTracked: Bool!
    private var addressInfo: (BalanceModel, TransactionsCountModel)?
    private var loadedTransactions: [DetailedTransactionModel]
    
    // MARK: - Init
    required init(address: String, view: AddressInfoView, networkManager: NetworkManager, trackingService: AddressTrackingService) {
        self.view = view
        self.networkManager = networkManager
        self.trackingService = trackingService
        
        self.address = address
        self.loadedTransactions = []
        
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
        
        let time = currentTransaction.time.formatUnixTime(style: .short)
        let hash = currentTransaction.hash.shorten(prefix: 7, suffix: 7)
        for input in currentTransaction.inputs {
            if input.address == self.address {
                let value = input.value.formatNumberString()
                completion(.sent, "-\(value) DOGE", time, hash)
                return
            }
        }
        
        for output in currentTransaction.outputs {
            if output.address == self.address {
                let value = output.value.formatNumberString()
                completion(.received, "+\(value) DOGE", time, hash)
                return
            }
        }
    }
    
    // MARK: - Tracking Methods
    func trackingStateDidChange() {
        if isAddressTracked {
            view?.showDeleteAlert()
        } else {
            guard trackingService.getAllTrackedAddresses().count < 10 else {
                view?.showOkActionSheet(title: "Limit", message: "You can track only 10 addresses")
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
    
    func deleteTracking() {
        trackingService.deleteTracking(address)
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
        guard let allTransactionsCount = addressInfo?.1.info.total else { return }
        let difference = allTransactionsCount - loadedTransactions.count
        guard difference > 0 else { return }
        let pageToLoad = (loadedTransactions.count / 10) + 1
        view?.animateLoadTransactionLoader(true)
        Task { @MainActor in
            do {
                let start = Date()
                
                let transactions = try await networkManager.getDetailedTransactionsPage(for: address, page: pageToLoad)
                loadedTransactions += transactions
                loadedTransactions.sort { $0.transaction.time > $1.transaction.time }
                view?.animateLoadTransactionLoader(false)
                if difference <= 10 { view?.hideLoadTransactionsButton() }
                print("full transaction page loading time: \(Date().timeIntervalSince(start))")
                
                view?.reloadData()
            } catch {
                print(error, #function)
            }
        }
    }
    
    func didSelectTransaction(at indexPath: IndexPath) {
        view?.showTransactionInfoViewController()
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
                async let transactions = networkManager.getDetailedTransactionsPage(for: address, page: 1)
                
                addressInfo = try await info
                loadedTransactions.append(contentsOf: try await transactions)
                
                if let addressInfo, addressInfo.1.info.total <= 10 {
                    view?.hideLoadTransactionsButton()
                }
                
                loadedTransactions.sort { $0.transaction.time > $1.transaction.time }
                
                print("base info loading time: \(Date().timeIntervalSince(start))")
                
                view?.initialConfigure(address: address.shorten(prefix: 7, suffix: 7),
                                       dogeBalance: "\(addressInfo!.0.balance.formatNumberString()) DOGE",
                                       transactionsCount: "Transactions: \(addressInfo!.1.info.total)")
            } catch {
                view?.showOkActionSheet(title: ":/", message: error.localizedDescription)
            }
            view?.animateCentralLoader(false)
        }
    }
}
