//
//  MainPresenterProtocol.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 27.04.2023.
//

import Foundation

typealias MainPresenter = MainPresenterEventHandling & MainPresenterViewConfiguring & MainPresenterActions

protocol MainPresenterEventHandling {
    func viewWillAppear()
    func didSelectAddress(at indexPath: IndexPath)
    func searchButtonDidTap(with text: String?)
}

protocol MainPresenterViewConfiguring {
    func getNumberOfTrackedAddresses() -> Int
    func configureCell(at indexPath: IndexPath, completion: @escaping (_ name: String, _ address: String) -> Void)
    func getNameForAddress(at indexPath: IndexPath) -> String?
}

protocol MainPresenterActions {
    func deleteTrackingForAddress(at indexPath: IndexPath)
    func renameAddress(at indexPath: IndexPath, newName: String?)
}
