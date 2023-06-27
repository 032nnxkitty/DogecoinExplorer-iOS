//
//  MainViewModel.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 27.04.2023.
//

import Foundation

protocol MainViewModel {
    var observableErrorMessage: ObservableObject<(title: String, message: String)> { get }
    var numberOfTrackedAddresses: Int { get }
    
    func getViewModelForAddress(at indexPath: IndexPath) -> TrackedAddressCellViewModel
    func addTracking(address: String, name: String)
    func deleteAddress(at indexPath: IndexPath)
    func renameAddress(at indexPath: IndexPath, newName: String)
    func searchButtonDidTap(text: String?)
}
