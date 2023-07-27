//
//  AddressInfoViewProtocol.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.07.2023.
//

import Foundation

protocol AddressInfoViewModel {
    var observableViewState: Observable<AddressInfoViewState> { get }
    
    func viewDidLoad()
    
    var address: String { get }
    
    var formattedBalance: String { get }
    
    var totalTransactionsCount: String { get }
    
    var isTracked: Bool { get }
    
    func startTracking(name: String?)
    
    func rename(newName: String?)
    
    func deleteTracking()
    
    var numberOfLoadedTransactions: Int { get }
    
    func getViewModelForTransaction(at indexPath: IndexPath) -> TransactionCellViewModel
    
    func loadMoreTransactions()
    
    func didSelectTransaction(at indexPath: IndexPath)
}
