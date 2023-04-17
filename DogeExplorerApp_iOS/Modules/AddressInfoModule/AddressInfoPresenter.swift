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
    func configureTransactionCell(at indexPath: IndexPath, completion: @escaping (String, String) -> Void)
}

final class AddressInfoPresenterImp: AddressInfoPresenter {
    private weak var view: AddressInfoView?
    private let networkManager: NetworkManager
    private let trackingService: AddressTrackingService
    
    private let address: String
    private var isAddressTracking: Bool!
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
        self.loadedTransactions = [DetailedTransactionModel(success: nil, transaction: nil),
                                   DetailedTransactionModel(success: nil, transaction: nil),
                                   DetailedTransactionModel(success: nil, transaction: nil),
                                   DetailedTransactionModel(success: nil, transaction: nil)]
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
        guard indexPath.row <= infoSectionModel.count else { return }
        let title = infoSectionModel[indexPath.row][0]
        let value = infoSectionModel[indexPath.row][1]
        completion(title, value)
    }
    
    func configureTransactionCell(at indexPath: IndexPath, completion: @escaping (String, String) -> Void) {
        // guard transactions count
        let title = "Send / Received #\(indexPath.section + 1)"
        let value = "other_info_imitation"
        completion(title, value)
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
}

// MARK: - Private Methods
private extension AddressInfoPresenterImp {
    func configureTrackingState() {
        if let trackedAddress = trackingService.getTrackedAddressModel(for: address) {
            isAddressTracking = true
            view?.configureIfAddressTracked(name: trackedAddress.name)
        } else {
            isAddressTracking = false
            view?.configureIfAddressNotTracked(shortenAddress: address.shortenAddress(prefix: 5, suffix: 4))
        }
    }
    
    func getBaseAddressInfo() {
        Task { @MainActor in
            do {
                addressInfo = try await networkManager.getAddressInfo(address)
                view?.reloadData()
            } catch {
                print("failure while loading address information")
            }
        }
    }
}
