//
//  MainViewModelImpl.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation
import UIKit.UIApplication

final class MainViewModelImpl: MainViewModel {
    private let internetConnectionObserver = InternetConnectionObserver.shared
    private let networkManager: NetworkManager
    private let storageManager: StorageManager
    
    // MARK: - Init
    init(networkManager: NetworkManager, storageManager: StorageManager) {
        self.networkManager = networkManager
        self.storageManager = storageManager
        
//        storageManager.addMockData()
    }
    
    // MARK: - Protocol Methods & Properties
    var observableViewState: Observable<MainViewState> = .init(value: .initial)
    
    var trackedAddresses: [(address: String, name: String)] {
        let addresses = storageManager.trackedAddresses
        
        observableViewState.value = addresses.count == 0 ? .emptyList : .filledList
        
        return addresses.map { ($0.address?.shorten(prefix: 5, suffix: 5) ?? "...", $0.name ?? "...") }
        
    }
    
    func deleteAddress(at indexPath: IndexPath) {
        guard let addressToDelete = storageManager.trackedAddresses[indexPath.row].address else { return }
        storageManager.deleteAddress(addressToDelete)
        
        observableViewState.value = .message(text: "Address successfully deleted")
    }
    
    func renameAddress(at indexPath: IndexPath, newName: String?) {
        guard let newName else { return }
        guard let addressToRename = storageManager.trackedAddresses[indexPath.row].address else { return }
        storageManager.renameAddress(addressToRename, newName: newName)
        
        observableViewState.value = .message(text: "Address successfully renamed")
    }
    
    func didTapSearchButton(text: String?) {
        guard internetConnectionObserver.isReachable else {
            observableViewState.value = .message(text: "No internet connection")
            return
        }
        
        guard let address = text?.trimmingCharacters(in: .whitespaces), address.count == 34 else {
            observableViewState.value = .message(text: "Invalid address format")
            return
        }
        
        self.loadInfo(for: address)
    }
    
    func didSelectAddress(at indexPath: IndexPath) {
        guard internetConnectionObserver.isReachable else {
            observableViewState.value = .message(text: "No internet connection")
            return
        }
        
        guard let address = storageManager.trackedAddresses[indexPath.row].address else {
            observableViewState.value = .message(text: "Something went wrong :(")
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
        observableViewState.value = .startLoader
        Task { @MainActor in
            defer {
                observableViewState.value = .finishLoader
            }
            
            do {
                let balanceModel = try await networkManager.loadBalance(for: address)
                async let transactionsCountModel = networkManager.loadTransactionsCount(for: address)
                async let firstTransactionsPage = networkManager.loadDetailedTransactionsPage(for: address, page: 1)
                let name = storageManager.getName(for: address)
                
                let addressInfoModel = try await AddressInfoModel(
                    address: address,
                    trackingName: name,
                    balanceModel: balanceModel,
                    transactionsCountModel: transactionsCountModel,
                    transactions: firstTransactionsPage
                )
                
                observableViewState.value = .push(model: addressInfoModel)
                
            } catch let error as NetworkError {
                observableViewState.value = .message(text: error.description)
            } catch _ {
                observableViewState.value = .message(text: "Something went wrong :(")
            }
        }
    }
}
