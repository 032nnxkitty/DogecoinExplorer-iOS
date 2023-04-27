//
//  DogechainAPIEndpoint.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.04.2023.
//

import Foundation

enum DogechainAPIEndpoint {
    case balance(address: String)
    case amountSent(address: String)
    case amountReceived(address: String)
    case transactionsCount(address: String)
    case transactionsPage(address: String, page: Int)
    case transactionInfo(hash: String)
    
    private var baseURL: String {
        return "https://dogechain.info/api/v1/"
    }
    
    private var path: String {
        switch self {
        case .balance(let address):
            return "address/balance/\(address)"
        case .amountSent(let address):
            return "address/sent/\(address)"
        case .amountReceived(let address):
            return "address/received/\(address)"
        case .transactionsCount(let address):
            return "address/transaction_count/\(address)"
        case .transactionsPage(let address, let page):
            return "address/transactions/\(address)/\(page)"
        case .transactionInfo(let hash):
            return "transaction/\(hash)"
        }
    }
    
    var url: URL? {
        return URL(string: path, relativeTo: URL(string: baseURL))
    }
}
