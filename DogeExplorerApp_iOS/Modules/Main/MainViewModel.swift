//
//  MainPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation
import UIKit.UIApplication

protocol MainViewModel {
    var numberOfTrackedAddresses: Int { get }
    
    func getViewModelForAddress(at indexPath: IndexPath) -> (address: String, name: String)
    
    func deleteAddress(at indexPath: IndexPath)
    
    func renameAddress(at indexPath: IndexPath, newName: String?)
    
    func searchButtonDidTap(text: String?)
    
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
    
    // MARK: - In Memory Storage !!!
    
    // MARK: - Protocol Methods & Properties
    var numberOfTrackedAddresses: Int {
        return storageManager.trackedAddresses.count
    }
    
    func getViewModelForAddress(at indexPath: IndexPath) -> (address: String, name: String) {
        let currentModel = storageManager.trackedAddresses[indexPath.row]
        let name = currentModel.name ?? "No name"
        let address = currentModel.address?.shorten(prefix: 5, suffix: 5) ?? "Something went wrong :/"
        return (address, name)
    }
    
    func deleteAddress(at indexPath: IndexPath) {
        guard let addressToDelete = storageManager.trackedAddresses[indexPath.row].address else { return }
        storageManager.deleteAddress(addressToDelete)
        AlertKit.presentToast(message: "Address successfully deleted")
    }
    
    func renameAddress(at indexPath: IndexPath, newName: String?) {
        guard let newName else { return }
        guard let addressToRename = storageManager.trackedAddresses[indexPath.row].address else { return }
        storageManager.renameAddress(addressToRename, newName: newName)
        AlertKit.presentToast(message: "Address successfully renamed")
    }
    
    func searchButtonDidTap(text: String?) {
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
        
        guard let address = storageManager.trackedAddresses[indexPath.row].address else {
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
            do {
                let (balanceModel, transactionsCountModel) = try await networkManager.loadInfoForAddress(address)
                // open address info vc
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
            LoaderKit.hideLoader()
        }
    }
}