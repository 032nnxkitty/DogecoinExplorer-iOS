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
    
}

class NetworkManagerImp: NetworkManager {
    func getAddressInfo(_ address: String) async throws -> (BalanceModel, SentModel, ReceivedModel, TransactionsCountModel) {
        async let balance           = request(url: URLBuilder.balanceURL(for: address), decodeTo: BalanceModel.self)
        async let sent              = request(url: URLBuilder.sentURL(for: address), decodeTo: SentModel.self)
        async let received          = request(url: URLBuilder.receivedURL(for: address), decodeTo: ReceivedModel.self)
        async let transactionsCount = request(url: URLBuilder.transactionsCountURL(for: address), decodeTo: TransactionsCountModel.self)
        return try await (balance, sent, received, transactionsCount)
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
