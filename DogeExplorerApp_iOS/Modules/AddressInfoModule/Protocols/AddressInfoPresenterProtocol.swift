//
//  AddressInfoPresenterProtocol.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 27.04.2023.
//

import Foundation

typealias AddressInfoPresenter = AddressInfoPresenterEventHandling & AddressInfoPresenterActions & AddressInfoPresenterViewConfiguring

protocol AddressInfoPresenterEventHandling {
    func trackingStateDidChange()
    func renameButtonDidTap()
    func loadTransactionsButtonDidTap()
    func didSelectTransaction(at indexPath: IndexPath)
}

protocol AddressInfoPresenterActions {
    func addTracking(with name: String?)
    func renameAddress(newName: String?)
}

protocol AddressInfoPresenterViewConfiguring {
    func getNumberOfLoadedTransactions() -> Int
    func configureTransactionCell(at indexPath: IndexPath) -> (style: TransactionStyle, value: String, time: String, hash: String)
    func getAddressName() -> String?
}
