//
//  TransactionsPageModel.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.04.2023.
//

import Foundation

struct TransactionsPageModel: Decodable {
    let transactions: [TransactionBaseInfo]
    let success: Int
    
}

struct TransactionBaseInfo: Decodable {
    let hash: String
    let value: String
    let time: Int
    let block: Int?
    let price: String
}
