//
//  TransactionsListModel.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.07.2023.
//

import Foundation

enum TransactionListModel: Int, CaseIterable {
    case details, inputs, outputs
    
    var title: String {
        return "\(self)".capitalized
    }
    
    enum DetailsListSection: Int, CaseIterable {
        case hash
        case confirmed
        case numberOfInputs
        case totalIn
        case numberOfOutputs
        case totalOut
        case size
        case fee
        case confirmations
        
        var title: String {
            switch self {
            case .confirmed:
                return "Confirmed at:"
            case .numberOfInputs:
                return "Number of inputs:"
            case .totalIn:
                return "Total in:"
            case .numberOfOutputs:
                return "Number of outputs:"
            case .totalOut:
                return "Total out:"
            default:
                return "\(self):".capitalized
            }
        }
    }
}
