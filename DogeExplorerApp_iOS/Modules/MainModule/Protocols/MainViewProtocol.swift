//
//  MainViewProtocol.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 27.04.2023.
//

import Foundation

protocol MainView: AnyObject {
    func showSettingsViewController()
    func showInfoViewController(for address: String)
    func showOkActionSheet(title: String, message: String)
    func reloadData()
}
