//
//  URLBuilder.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.04.2023.
//

import Foundation

struct URLBuilder {
    private static var baseURL: URL? {
        URL(string: "https://dogechain.info/api/v1/")
    }
    
    static func balanceURL(for address: String) -> URL? {
        return URL(string: "address/balance/\(address)", relativeTo: baseURL)
    }
    
    static func sentURL(for address: String) -> URL? {
        return URL(string: "address/sent/\(address)", relativeTo: baseURL)
    }
    
    static func receivedURL(for address: String) -> URL? {
        return URL(string: "address/received/\(address)", relativeTo: baseURL)
    }
    
    static func transactionsCountURL(for address: String) -> URL? {
        return URL(string: "address/transaction_count/\(address)", relativeTo: baseURL)
    }
    
    static func transactionsPageURL(for address: String, page: Int) -> URL? {
        return URL(string: "address/transactions/\(address)/\(page)", relativeTo: baseURL)
    }
    
    static func transactionInfoURL(hash: String) -> URL? {
        return URL(string: "transaction/\(hash)", relativeTo: baseURL)
    }
}

