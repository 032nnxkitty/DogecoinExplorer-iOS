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

protocol AddressInfoPresenter {
    init(address: String, view: AddressInfoView, networkManager: NetworkManager)
    
    func sectionDidChange(to section: Int)
    
    func getNumberOfSections() -> Int
    func getNumberOfRows() -> Int
    func configureInfoCell(at indexPath: IndexPath, completion: @escaping (String, String) -> Void)
    func configureTransactionCell(at indexPath: IndexPath, completion: @escaping (String, String, String) -> Void)
    
    func trackingStateDidChange()
    func renameButtonDidTap()
    func addTracking(with name: String?)
    func deleteTracking()
    func renameAddress(newName: String?)
    
    func isLoadMoreButtonVisible(_ section: Int) -> Bool
    func loadTransactionsButtonDidTap()
}

final class AddressInfoPresenterImp: AddressInfoPresenter {
    private weak var view: AddressInfoView?
    private let networkManager: NetworkManager
    private let trackingService: AddressTrackingService
    
    private let address: String
    private var isAddressTracked: Bool!
    private var addressInfo: (BalanceModel, SentModel, ReceivedModel, TransactionsCountModel)?
    private var loadedTransactions: [DetailedTransactionModel]
    
    private var showingSection: ShowingSection
    
    private var infoSectionModel: [[String]] {
        guard let addressInfo else { return [] }
        return [["Address:",              address],
                ["Balance:",            "\(addressInfo.0.balance.formatNumberString()) DOGE"],
                ["Amount sent:",        "\(addressInfo.1.sent.formatNumberString()) DOGE"],
                ["Amount received:",    "\(addressInfo.2.received.formatNumberString()) DOGE"],
                ["Transactions count:", "\(addressInfo.3.info.total)"]]
    }
    
    // MARK: - Init
    required init(address: String, view: AddressInfoView, networkManager: NetworkManager) {
        self.view = view
        self.networkManager = networkManager
        self.trackingService = UserDefaults.standard
        
        self.address = address
        self.loadedTransactions = []
        self.showingSection = .info
        
        configureTrackingState()
        getBaseAddressInfo()
    }
    
    // MARK: - Public Methods
    func getNumberOfSections() -> Int {
        switch showingSection {
        case .info:
            return 1
        case .transactions:
            return loadedTransactions.count
        }
    }
    
    func getNumberOfRows() -> Int {
        switch showingSection {
        case .info:
            return infoSectionModel.count
        case .transactions:
            return 1
        }
    }
    
    func configureInfoCell(at indexPath: IndexPath, completion: @escaping (String, String) -> Void) {
        guard indexPath.row < infoSectionModel.count else { return }
        let title = infoSectionModel[indexPath.row][0]
        let value = infoSectionModel[indexPath.row][1]
        completion(title, value)
    }
    
    func configureTransactionCell(at indexPath: IndexPath, completion: @escaping (String, String, String) -> Void) {
        guard indexPath.section < loadedTransactions.count else { return }
        let currentTransaction = loadedTransactions[indexPath.section].transaction
        
        let time = currentTransaction.time.formatUnixTime(style: .short)
        
        for input in currentTransaction.inputs {
            if input.address == self.address {
                let value = input.value.formatNumberString()
                completion("Sent \(indexPath.section + 1)", "\(value) DOGE\n\(time)", "arrow.up.to.line.alt")
                return
            }
        }
        
        for output in currentTransaction.outputs {
            if output.address == self.address {
                let value = output.value.formatNumberString()
                completion("Received \(indexPath.section + 1)", "\(value) DOGE\n\(time)", "arrow.down.to.line.alt")
                return
            }
        }
    }
    
    func sectionDidChange(to section: Int) {
        showingSection = ShowingSection(rawValue: section)!
        switch showingSection {
        case .info:
            view?.configureInfoSection()
        case .transactions:
            view?.configureTransactionsSection()
        }
        view?.reloadData()
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
    
    func renameButtonDidTap() {
        view?.showRenameAlert()
    }
    
    func addTracking(with name: String?) {
        guard let name, !name.isEmpty else {
            trackingService.addNewTrackedAddress(TrackedAddress(name: "No name", address: address))
            configureTrackingState()
            return
        }
        trackingService.addNewTrackedAddress(TrackedAddress(name: name, address: address))
        configureTrackingState()
    }
    
    func deleteTracking() {
        trackingService.deleteTracking(address)
        configureTrackingState()
    }
    
    
    func renameAddress(newName: String?) {
        guard let newName, !newName.isEmpty else { return }
        trackingService.renameAddress(address, to: newName)
        configureTrackingState()
    }
    
    // MARK: - Load Transactions Methods
    func isLoadMoreButtonVisible(_ section: Int) -> Bool {
        guard showingSection == .transactions else { return false }
        guard section == loadedTransactions.count - 1 else { return false }
        return true
    }
    
    func loadTransactionsButtonDidTap() {
        guard let allTransactionsCount = addressInfo?.3.info.total else { return }
        let difference = allTransactionsCount - loadedTransactions.count
        guard difference > 0 else { return }
        if difference <= 10 { view?.hideLoadTransactionsButton() }
        let pageToLoad = (loadedTransactions.count / 10) + 1
        view?.animateLoadTransactionLoader(true)
        Task { @MainActor in
            do {
                let start = Date()
                
                let transactions = try await networkManager.getDetailedTransactionsPage(for: address, page: pageToLoad)
                loadedTransactions += transactions
                loadedTransactions.sort { $0.transaction.time > $1.transaction.time }
                view?.animateLoadTransactionLoader(false)
                
                print("full transaction page loading time: \(Date().timeIntervalSince(start))")
                
                view?.reloadData()
            } catch {
                print(error, #function)
            }
        }
    }
}

// MARK: - Private Methods
private extension AddressInfoPresenterImp {
    func configureTrackingState() {
        if let trackedAddress = trackingService.getTrackedAddressModel(for: address) {
            isAddressTracked = true
            view?.configureIfAddressTracked(name: trackedAddress.name)
        } else {
            isAddressTracked = false
            view?.configureIfAddressNotTracked(shortenAddress: address.shortenAddress(prefix: 5, suffix: 4))
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
                
                if let addressInfo, addressInfo.3.info.total <= 10 {
                    view?.hideLoadTransactionsButton()
                }
                
                loadedTransactions.sort { $0.transaction.time > $1.transaction.time }
                
                print("base info loading time: \(Date().timeIntervalSince(start))")
                
                view?.reloadData()
            } catch {
                view?.showOkActionSheet(title: ":/", message: error.localizedDescription)
            }
            view?.animateCentralLoader(false)
        }
    }
}
