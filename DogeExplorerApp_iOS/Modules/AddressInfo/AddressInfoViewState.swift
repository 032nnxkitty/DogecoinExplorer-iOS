//
//  AddressInfoViewState.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.07.2023.
//

import Foundation

enum AddressInfoViewState {
    case initial
    
    case startTrackAlert
    
    case becomeTracked(name: String)
    
    case renameAlert(oldName: String?)
    
    case becomeUntracked
    
    case startLoadTransactions
    
    case finishLoadTransactions
    
    case allTransactionsLoaded
    
    case message(text: String)
    
    case push(model: TransactionInfoModel)
}
