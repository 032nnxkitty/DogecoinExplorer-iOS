//
//  DetailedTransactionInfoModel.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.04.2023.
//

import Foundation

struct TransactionInfoModel: Decodable {
    let success: Int?
    let transaction: Transaction
    
    struct Transaction: Decodable {
        let hash: String?
        let confirmations: Int?
        let size: Int?
        let vsize: Int?
        let weight: Int?
        let version: Int?
        let locktime: Int?
        let blockHash: String?
        let time: Int?
        let inputsN: Int?
        let inputsValue: String?
        let inputs: [Input]?
        let outputsN: Int?
        let outputsValue: String?
        let outputs: [Output]?
        let fee: String?
        let price: String?
        
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
    
    struct Input: Decodable {
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
    
    struct PreviousOutput: Decodable {
        let hash: String?
        let pos: Int?
    }
    
    struct ScriptSig: Decodable {
        let hex: String?
    }
    
    struct Output: Decodable {
        let pos: Int?
        let value: String?
        let type: String?
        let address: String?
        let script: Script?
        let spent: PreviousOutput?
    }
    
    struct Script: Decodable {
        let hex: String?
        let asm: String?
    }
}

