//
//  TransactionInfoViewModelProtocol.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.07.2023.
//

import Foundation

protocol TransactionInfoViewModel {
    var observableViewState: Observable<TransactionInfoState> { get }
    
    var numberOfSections: Int { get }
    
    func getNumberOfItems(in section: Int) -> Int
    
    func getTitle(for section: Int) -> String?
    
    func configureDetailCell(at indexPath: IndexPath) -> (title: String, value: String)
    
    func configureInputCell(at indexPath: IndexPath) -> (from: String, amount: String)
    
    func configureOutputCell(at indexPath: IndexPath) -> (to: String, amount: String)
    
    func didTapCell(at indexPath: IndexPath)
    
    func didTapSupportView() 
}
