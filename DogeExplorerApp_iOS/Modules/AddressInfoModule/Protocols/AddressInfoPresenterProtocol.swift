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
    func getNumberOfTransactions() -> Int
    func configureTransactionCell(at indexPath: IndexPath, completion: @escaping (_ style: TransactionStyle, _ value: String, _ time: String, _ hash: String) -> Void)
    func getAddressName() -> String?
}
