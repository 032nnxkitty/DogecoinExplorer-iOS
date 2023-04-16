//
//  AddressInfoPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

protocol AddressInfoPresenter {
    init(address: String, view: AddressInfoView, networkManager: NetworkManager)
    func getNumberOfInfoRows() -> Int
    func configureCell(at indexPath: IndexPath, completion: @escaping (String, String) -> Void)
    func sectionDidChange(to section: Int)
}

final class AddressInfoPresenterImp: AddressInfoPresenter {
    private weak var view: AddressInfoView?
    private let networkManager: NetworkManager
    private let trackingService: AddressTrackingService
    
    private let address: String
    private var addressInfo: (BalanceModel, SentModel, ReceivedModel, TransactionsCountModel)?
    
    private var infoSectionModule: [[String]] {
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
        self.address = address
        self.trackingService = UserDefaults.standard
        initialize()
    }
    
    // MARK: - Public Methods
    func getNumberOfInfoRows() -> Int {
        return infoSectionModule.count
    }
    
    func configureCell(at indexPath: IndexPath, completion: @escaping (String, String) -> Void) {
        guard indexPath.row <= infoSectionModule.count else { return }
        let title = infoSectionModule[indexPath.row][0]
        let value = infoSectionModule[indexPath.row][1]
        completion(title, value)
    }
    
    func sectionDidChange(to section: Int) {
        section == 0 ? view?.configureInfoSection() : view?.configureTransactionsSection()
        view?.reloadData()
    }
}

// MARK: - Private Methods
private extension AddressInfoPresenterImp {
    func initialize() {
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
