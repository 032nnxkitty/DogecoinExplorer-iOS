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
    func checkAddressExistence(_ address: String) async throws -> Bool
    func getAddressInfo(_ address: String) async throws -> (BalanceModel, TransactionsCountModel)
    func getDetailedTransactionsPage(for address: String, page: Int) async throws -> [DetailedTransactionModel]
}

class NetworkManagerImp: NetworkManager {
    func checkAddressExistence(_ address: String) async throws -> Bool {
        let balanceUrl = URL(string: "https://dogechain.info/api/v1/address/balance/\(address)")
        
        do {
            let _ = try await request(url: balanceUrl, decodeTo: BalanceModel.self)
            return true
        } catch {
            return false
        }
    }
    
    func getAddressInfo(_ address: String) async throws -> (BalanceModel, TransactionsCountModel) {
        let balanceUrl           = URL(string: "https://dogechain.info/api/v1/address/balance/\(address)")
        let transactionsCountUrl = URL(string: "https://dogechain.info/api/v1/address/transaction_count/\(address)")
        
        async let balance           = request(url: balanceUrl, decodeTo: BalanceModel.self)
        async let transactionsCount = request(url: transactionsCountUrl, decodeTo: TransactionsCountModel.self)
        
        return try await (balance, transactionsCount)
    }
    
    func getDetailedTransactionsPage(for address: String, page: Int) async throws -> [DetailedTransactionModel] {
        let pageUrl = URL(string: "https://dogechain.info/api/v1/address/transactions/\(address)/\(page)")
        
        let transactionPage = try await request(url: pageUrl, decodeTo: TransactionsPageModel.self)
        
        var detailedTransactionsPage: [DetailedTransactionModel] = []
        return try await withThrowingTaskGroup(of: DetailedTransactionModel.self, returning: [DetailedTransactionModel].self) { taskGroup in
            for transaction in transactionPage.transactions {
                
                let hash = transaction.hash
                let transactionInfoUrl = URL(string: "https://dogechain.info/api/v1/transaction/\(hash)")
                
                taskGroup.addTask {
                    let transaction = try await self.request(url: transactionInfoUrl, decodeTo: DetailedTransactionModel.self)
                    return transaction
                }
            }
            
            for try await transaction in taskGroup {
                detailedTransactionsPage.append(transaction)
            }
            
            return detailedTransactionsPage
        }
    }
}

// MARK: - Private Generic Request
private extension NetworkManagerImp {
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
