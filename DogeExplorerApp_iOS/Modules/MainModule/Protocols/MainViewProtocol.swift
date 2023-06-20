//
//  MainViewProtocol.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 27.04.2023.
//

import Foundation

protocol MainView: AnyObject {
    func showInfoViewController(for address: String, addressInfo: (BalanceModel, TransactionsCountModel))
    func showOkActionSheet(title: String, message: String)
    func reloadData()
    func showNoTrackedAddressesView(_ isVisible: Bool)
    func animateLoader(_ isAnimated: Bool)
}
