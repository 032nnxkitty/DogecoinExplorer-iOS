//
//  AddressInfoModel.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 20.07.2023.
//

import Foundation

struct AddressInfoModel {
    let address: String
    var trackingName: String? 
    let balanceModel: BalanceModel
    let transactionsCountModel: TransactionsCountModel
    let transactions: [TransactionInfoModel]
}
