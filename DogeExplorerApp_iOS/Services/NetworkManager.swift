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

final class NetworkManagerImp: NetworkManager {
    func checkAddressExistence(_ address: String) async throws -> Bool {
        do {
            let _ = try await request(url: URLs.getBalance(for: address), decodeTo: BalanceModel.self)
            return true
        } catch {
            return false
        }
    }
    
    func getAddressInfo(_ address: String) async throws -> (BalanceModel, TransactionsCountModel) {
        async let balance           = request(url: URLs.getBalance(for: address), decodeTo: BalanceModel.self)
        async let transactionsCount = request(url: URLs.getTransactionsCount(for: address), decodeTo: TransactionsCountModel.self)
        return try await (balance, transactionsCount)
    }
    
    func getDetailedTransactionsPage(for address: String, page: Int) async throws -> [DetailedTransactionModel] {
        let transactionPage = try await request(url: URLs.getTransactionsPage(for: address, page: page), decodeTo: TransactionsPageModel.self)
        
        var detailedTransactionsPage: [DetailedTransactionModel] = []
        return try await withThrowingTaskGroup(of: DetailedTransactionModel.self, returning: [DetailedTransactionModel].self) { taskGroup in
            for transaction in transactionPage.transactions {
                taskGroup.addTask {
                    let transaction = try await self.request(url: URLs.getTransactionInfo(hash: transaction.hash), decodeTo: DetailedTransactionModel.self)
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
