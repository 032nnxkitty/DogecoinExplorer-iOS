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
    
    // MARK: - Protocol Methods
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
    }
    
    func renameAddress(at indexPath: IndexPath, newName: String?) {
        guard let newName else { return }
        guard let addressToRename = storageManager.trackedAddresses[indexPath.row].address else { return }
        storageManager.renameAddress(addressToRename, newName: newName)
    }
    
    func searchButtonDidTap(text: String?) {
        guard internetConnectionObserver.isReachable else {
            ToastKit.present(message: "No internet connection")
            return
        }
        
        guard let address = text?.trimmingCharacters(in: .whitespaces), address.count == 34 else {
            ToastKit.present(message: "Invalid address format")
            return
        }
        
        self.loadInfo(for: address)
    }
    
    func didSelectAddress(at indexPath: IndexPath) {
        guard internetConnectionObserver.isReachable else {
            ToastKit.present(message: "No internet connection")
            return
        }
        
        self.loadInfo(for: "add")
    }
    
    func didTapSupportView() {
        guard let url = URL(string: "https://github.com/032nnxkitty/DogecoinExplorer-iOS") else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - Private Methods
private extension MainViewModelImpl {
    func loadInfo(for address: String) {
        Task { @MainActor in
            do {
                let info = try await networkManager.loadInfoForAddress(address)
            } catch let error as NetworkError {
                switch error {
                case .invalidURL:
                    ToastKit.present(message: "Invalid URL :/")
                case .httpError(let statusCode):
                    ToastKit.present(message: "Error status code: \(statusCode)")
                case .decodeError:
                    fallthrough
                case .badServerResponse:
                    ToastKit.present(message: "Something went wrong :(")
                case .addressNotFound:
                    ToastKit.present(message: "Address not found")
                }
            } catch _ {
                ToastKit.present(message: "Something went wrong :(")
            }
        }
    }
}
