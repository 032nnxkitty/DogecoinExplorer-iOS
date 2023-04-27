//
//  BalanceModel.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.04.2023.
//

import Foundation

struct BalanceModel: Decodable {
    var balance: String
    var confirmed: String
    var unconfirmed: String
    var success: Int
}
