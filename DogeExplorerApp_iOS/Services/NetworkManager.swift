//
//  NetworkManager.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 15.04.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case httpError(statusCode: Int)
    case decodeError
    case badServerResponse
    case addressNotFound
}

protocol NetworkManager {
    func loadInfoForAddress(_ address: String) async throws -> (BalanceModel, TransactionsCountModel)
    func loadDetailedTransactionsPage(for address: String, page: Int) async throws -> [DetailedTransactionModel]
}

final class URLSessionNetworkManager: NetworkManager {
    static let shared = URLSessionNetworkManager()
    private init() {}
    
    func loadInfoForAddress(_ address: String) async throws -> (BalanceModel, TransactionsCountModel) {
        let balanceUrl           = URL(string: "https://dogechain.info/api/v1/address/balance/\(address)")
        let transactionsCountUrl = URL(string: "https://dogechain.info/api/v1/address/transaction_count/\(address)")
        
        var balanceModel: BalanceModel
        do {
            balanceModel = try await request(url: balanceUrl)
        } catch NetworkError.decodeError {
            throw NetworkError.addressNotFound
        }
        
        let transactionsCountModel: TransactionsCountModel = try await request(url: transactionsCountUrl)
        
        return (balanceModel, transactionsCountModel)
    }
    
    func loadDetailedTransactionsPage(for address: String, page: Int) async throws -> [DetailedTransactionModel] {
        let pageUrl = URL(string: "https://dogechain.info/api/v1/address/transactions/\(address)/\(page)")
        
        let transactionPage: TransactionsPageModel = try await request(url: pageUrl)
        
        var detailedTransactionsPage: [DetailedTransactionModel] = []
        return try await withThrowingTaskGroup(of: DetailedTransactionModel.self, returning: [DetailedTransactionModel].self) { [weak self] taskGroup in
            guard let self else { return [] }
            for transaction in transactionPage.transactions {
                
                let hash = transaction.hash
                let transactionInfoUrl = URL(string: "https://dogechain.info/api/v1/transaction/\(hash)")
                
                taskGroup.addTask {
                    let transaction: DetailedTransactionModel = try await self.request(url: transactionInfoUrl)
                    return transaction
                }
            }
            
            for try await res in taskGroup {
                detailedTransactionsPage.append(res)
            }
            
            return detailedTransactionsPage
        }
    }
}

// MARK: - Private Generic Request
private extension URLSessionNetworkManager {
    func request<T: Decodable>(url: URL?) async throws -> T {
        guard let url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.badServerResponse
        }
        
        guard (200..<299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.decodeError
        }
        
        return result
    }
}
