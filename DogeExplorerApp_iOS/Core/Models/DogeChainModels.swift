//
//  DogeChainModels.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.04.2023.
//

import Foundation

// MARK: - Balance Model
struct BalanceModel: Decodable {
    var balance: String
    var confirmed: String
    var unconfirmed: String
    var success: Int
}

// MARK: - Amount Sent Model
struct SentModel: Decodable {
    var sent: String
    var success: Int
}

// MARK: - Amount Received Model
struct ReceivedModel: Decodable {
    var received: String
    var success: Int
}

// MARK: - Transactions Count Model
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

// MARK: - Transactions Page Model
struct TransactionsPageModel: Codable {
    let transactions: [TransactionBaseInfo]
    let success: Int
    
}

struct TransactionBaseInfo: Codable {
    let hash: String
    let value: String
    let time: Int
    let block: Int
    let price: String
}

// MARK: - Detail Transaction Info Model
struct DetailTransactionInfoModel: Codable {
    let success: Int?
    let transaction: Transaction?
}

struct Transaction: Codable {
    let hash: String?
    let confirmations: Int?
    let size: Int?
    let vsize: Int?
    let weight: Int?
    let version: Int?
    let locktime: Int?
    let blockHash: String?
    let time, inputsN: Int?
    let inputsValue: String?
    let inputs: [Input]?
    let outputsN: Int?
    let outputsValue: String?
    let outputs: [Output]?
    let fee, price: String?
    
    private enum CodingKeys: String, CodingKey {
        case hash, confirmations, size, vsize, weight, version, locktime
        case blockHash = "block_hash"
        case time
        case inputsN = "inputs_n"
        case inputsValue = "inputs_value"
        case inputs
        case outputsN = "outputs_n"
        case outputsValue = "outputs_value"
        case outputs, fee, price
    }
}

struct Input: Codable {
    let pos: Int?
    let value: String?
    let address: String?
    let scriptSig: ScriptSig?
    let previousOutput: PreviousOutput?
    
    private enum CodingKeys: String, CodingKey {
        case pos, value, address, scriptSig
        case previousOutput = "previous_output"
    }
}

struct PreviousOutput: Codable {
    let hash: String?
    let pos: Int?
}

struct ScriptSig: Codable {
    let hex: String?
}

struct Output: Codable {
    let pos: Int?
    let value: String?
    let type: String?
    let address: String?
    let script: Script?
    let spent: PreviousOutput?
}

struct Script: Codable {
    let hex: String
    let asm: String?
}



