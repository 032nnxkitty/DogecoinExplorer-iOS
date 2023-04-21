//
//  URLBuilder.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.04.2023.
//

import Foundation

enum URLs {
    private static var baseURL: URL? {
        URL(string: "https://dogechain.info/api/v1/")
    }
    
    static func getBalance(for address: String) -> URL? {
        return URL(string: "address/balance/\(address)", relativeTo: baseURL)
    }
    
    static func getAmountSent(for address: String) -> URL? {
        return URL(string: "address/sent/\(address)", relativeTo: baseURL)
    }
    
    static func getAmountReceived(for address: String) -> URL? {
        return URL(string: "address/received/\(address)", relativeTo: baseURL)
    }
    
    static func getTransactionsCount(for address: String) -> URL? {
        return URL(string: "address/transaction_count/\(address)", relativeTo: baseURL)
    }
    
    static func getTransactionsPage(for address: String, page: Int) -> URL? {
        return URL(string: "address/transactions/\(address)/\(page)", relativeTo: baseURL)
    }
    
    static func getTransactionInfo(hash: String) -> URL? {
        return URL(string: "transaction/\(hash)", relativeTo: baseURL)
    }
}

