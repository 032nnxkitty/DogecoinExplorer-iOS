//
//  BalanceModel.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.04.2023.
//

import Foundation

struct BalanceModel: Decodable {
    let balance: String
    let confirmed: String
    let unconfirmed: String
    let success: Int
}
