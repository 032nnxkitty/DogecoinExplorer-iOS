//
//  TransactionsCountModel.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.04.2023.
//

import Foundation

struct TransactionsCountModel: Decodable {
    let info: TransactionCountInfo
    let success: Int
    
    private enum CodingKeys: String, CodingKey {
        case info = "transaction_count"
        case success
    }
}

struct TransactionCountInfo: Decodable {
    let sent: Int
    let received: Int
    let total: Int
}
