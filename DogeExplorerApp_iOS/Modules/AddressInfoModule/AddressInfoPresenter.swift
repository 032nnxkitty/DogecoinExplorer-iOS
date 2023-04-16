//
//  AddressInfoPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

protocol AddressInfoPresenter {
    init(address: String, view: AddressInfoView, networkManager: NetworkManager)
}

final class AddressInfoPresenterImp: AddressInfoPresenter {
    private weak var view: AddressInfoView?
    private let networkManager: NetworkManager
    private let trackingService: AddressTrackingService
    
    private let address: String
    private var addressInfo: (BalanceModel, SentModel, ReceivedModel, TransactionsCountModel)?
    
    required init(address: String, view: AddressInfoView, networkManager: NetworkManager) {
        self.view = view
        self.networkManager = networkManager
        self.address = address
        self.trackingService = UserDefaults.standard
        initialize()
    }
}

// MARK: - Private Methods
private extension AddressInfoPresenterImp {
    func initialize() {
        Task {
            do {
                addressInfo = try await networkManager.getAddressInfo(address)
                print(address)
                print(addressInfo!.0.balance)
                print(addressInfo!.1.sent)
                print(addressInfo!.2.received)
                print(addressInfo!.3.info.total)
            } catch {
                print("failure while loading address information")
            }
        }
    }
}
