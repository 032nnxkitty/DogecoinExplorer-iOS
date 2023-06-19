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
}

protocol NetworkManager {
    func getAddressInfo(_ address: String) async throws -> (BalanceModel, TransactionsCountModel)
    func getDetailedTransactionsPage(for address: String, page: Int) async throws -> [DetailedTransactionModel]
}

final class URLSessionNetworkManager: NetworkManager {
    static let shared = URLSessionNetworkManager()
    private init() {}
    
    func getAddressInfo(_ address: String) async throws -> (BalanceModel, TransactionsCountModel) {
        let balanceUrl           = URL(string: "https://dogechain.info/api/v1/address/balance/\(address)")
        let transactionsCountUrl = URL(string: "https://dogechain.info/api/v1/address/transaction_count/\(address)")
        
        let balance           = try await request(url: balanceUrl, decodeTo: BalanceModel.self)
        let transactionsCount = try await request(url: transactionsCountUrl, decodeTo: TransactionsCountModel.self)
        
        return (balance, transactionsCount)
    }
    
    func getDetailedTransactionsPage(for address: String, page: Int) async throws -> [DetailedTransactionModel] {
        let pageUrl = URL(string: "https://dogechain.info/api/v1/address/transactions/\(address)/\(page)")
        
        let transactionPage = try await request(url: pageUrl, decodeTo: TransactionsPageModel.self)
        
        var detailedTransactionsPage: [DetailedTransactionModel] = []
        return try await withThrowingTaskGroup(of: DetailedTransactionModel.self,
                                               returning: [DetailedTransactionModel].self) { taskGroup in
            for transaction in transactionPage.transactions {
                
                let hash = transaction.hash
                let transactionInfoUrl = URL(string: "https://dogechain.info/api/v1/transaction/\(hash)")
                
                taskGroup.addTask {
                    let transaction = try await self.request(url: transactionInfoUrl, decodeTo: DetailedTransactionModel.self)
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
    func request<T: Decodable>(url: URL?, decodeTo: T.Type) async throws -> T {
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
