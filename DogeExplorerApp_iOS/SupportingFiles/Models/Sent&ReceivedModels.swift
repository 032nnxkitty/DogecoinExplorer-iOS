//
//  Sent&ReceivedModels.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.04.2023.
//

import Foundation

struct SentModel: Decodable {
    var sent: String
    var success: Int
}

struct ReceivedModel: Decodable {
    var received: String
    var success: Int
}
