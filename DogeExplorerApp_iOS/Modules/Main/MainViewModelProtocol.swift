//
//  MainViewModelProtocol.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.07.2023.
//

import Foundation

protocol MainViewModel {
    var observableViewState: Observable<MainViewState> { get }
    
    var trackedAddresses: [(address: String, name: String)] { get }
    
    func deleteAddress(at indexPath: IndexPath)
    
    func renameAddress(at indexPath: IndexPath, newName: String?)
    
    func didTapSearchButton(text: String?)
    
    func didSelectAddress(at indexPath: IndexPath)
    
    func didTapSupportView()
}
