//
//  TransactionCellViewModel.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 28.07.2023.
//

import Foundation

struct TransactionCellViewModel {
    let style: TransactionStyle
    let value: String
    let date: String
    let hash: String
    
    enum TransactionStyle: String {
        case sent, received
    }
}
