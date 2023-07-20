//
//  MainPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation
import UIKit.UIApplication

protocol MainViewModel {
    var trackedAddresses: [(address: String, name: String)] { get }
    
    func deleteAddress(at indexPath: IndexPath)
    
    func renameAddress(at indexPath: IndexPath, newName: String?)
    
    func didTapSearchButton(text: String?)
    
    func didSelectAddress(at indexPath: IndexPath)
    
    func didTapSupportView()
}

final class MainViewModelImpl: MainViewModel {
    private let internetConnectionObserver = InternetConnectionObserver.shared
    private let networkManager: NetworkManager
    private let storageManager: StorageManager
    
    // MARK: - Init
    init(networkManager: NetworkManager, storageManager: StorageManager) {
        self.networkManager = networkManager
        self.storageManager = storageManager
        
        storageManager.addMockData()
    }
    
    // MARK: - In Memory Storage
    private var inMemoryTrackedAddresses: [TrackedAddressEntity] = []
    private var needUpdateInMemoryTrackedAddresses: Bool = true
    
    // MARK: - Protocol Methods & Properties
    var trackedAddresses: [(address: String, name: String)] {
        get {
            if needUpdateInMemoryTrackedAddresses {
                inMemoryTrackedAddresses = storageManager.trackedAddresses
                needUpdateInMemoryTrackedAddresses = false
            }
            
            return inMemoryTrackedAddresses.map { ($0.address?.shorten(prefix: 5, suffix: 5) ?? "...", $0.name ?? "...") }
        }
    }
    
    func deleteAddress(at indexPath: IndexPath) {
        guard let addressToDelete = inMemoryTrackedAddresses[indexPath.row].address else { return }
        storageManager.deleteAddress(addressToDelete)
        AlertKit.presentToast(message: "Address successfully deleted")
        
        needUpdateInMemoryTrackedAddresses = true
    }
    
    func renameAddress(at indexPath: IndexPath, newName: String?) {
        guard let newName else { return }
        guard let addressToRename = inMemoryTrackedAddresses[indexPath.row].address else { return }
        storageManager.renameAddress(addressToRename, newName: newName)
        AlertKit.presentToast(message: "Address successfully renamed")
        
        needUpdateInMemoryTrackedAddresses = true
    }
    
    func didTapSearchButton(text: String?) {
        guard internetConnectionObserver.isReachable else {
            AlertKit.presentToast(message: "No internet connection")
            return
        }
        
        guard let address = text?.trimmingCharacters(in: .whitespaces), address.count == 34 else {
            AlertKit.presentToast(message: "Invalid address format")
            return
        }
        
        self.loadInfo(for: address)
    }
    
    func didSelectAddress(at indexPath: IndexPath) {
        guard internetConnectionObserver.isReachable else {
            AlertKit.presentToast(message: "No internet connection")
            return
        }
        
        guard let address = inMemoryTrackedAddresses[indexPath.row].address else {
            AlertKit.presentToast(message: "Something went wrong :(")
            return
        }
        
        self.loadInfo(for: address)
    }
    
    func didTapSupportView() {
        guard let url = URL(string: "https://github.com/032nnxkitty/DogecoinExplorer-iOS") else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - Private Methods
private extension MainViewModelImpl {
    func loadInfo(for address: String) {
        LoaderKit.showLoader()
        Task { @MainActor in
            defer {
                LoaderKit.hideLoader()
            }
            
            do {
                let balanceModel = try await networkManager.loadBalance(for: address)
                async let transactionsCountModel = networkManager.loadTransactionsCount(for: address)
                async let firstTransactionsPage = networkManager.loadDetailedTransactionsPage(for: address, page: 1)
                
                let addressInfoModel = try await AddressInfoModel(
                    address: address,
                    balanceModel: balanceModel,
                    transactionsCountModel: transactionsCountModel,
                    transactions: firstTransactionsPage
                )
                
                // transfer data
            } catch let error as NetworkError {
                switch error {
                case .invalidURL:
                    AlertKit.presentToast(message: "Invalid URL :/")
                case .httpError(let statusCode):
                    AlertKit.presentToast(message: "Error status code: \(statusCode)")
                case .decodeError:
                    fallthrough
                case .badServerResponse:
                    AlertKit.presentToast(message: "Something went wrong :(")
                case .addressNotFound:
                    AlertKit.presentToast(message: "Address not found")
                }
            } catch _ {
                AlertKit.presentToast(message: "Something went wrong :(")
            }
        }
    }
}
