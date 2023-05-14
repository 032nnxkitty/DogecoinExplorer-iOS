//
//  AddressInfoViewProtocol.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 27.04.2023.
//

import Foundation

typealias AddressInfoView = AddressInfoViewRouting & AddressInfoViewSettingData & AddressInfoViewAlertsPresenting & AddressInfoViewAnimating

protocol AddressInfoViewRouting: AnyObject {
}

protocol AddressInfoViewSettingData: AnyObject {
    func reloadData()
    func configureIfAddressTracked(name: String)
    func configureIfAddressNotTracked(shortenAddress: String)
    func setAddressInfo(address: String, dogeBalance: String, transactionsCount: String)
}

protocol AddressInfoViewAlertsPresenting: AnyObject {
    func showOkActionSheet(title: String, message: String)
    func showAddTrackingAlert()
    func showDeleteAlert()
    func showRenameAlert()
}

protocol AddressInfoViewAnimating: AnyObject {
    func animateCentralLoader(_ isAnimated: Bool)
    func animateLoadTransactionLoader(_ isAnimated: Bool)
    func hideLoadTransactionsButton()
}
