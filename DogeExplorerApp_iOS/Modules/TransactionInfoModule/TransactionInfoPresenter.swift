//
//  TransactionInfoPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 22.04.2023.
//

import Foundation

protocol TransactionInfoPresenter {
    init(view: TransactionInfoView)
}

class TransactionInfoPresenterImp: TransactionInfoPresenter {
    private let view: TransactionInfoView
    
    init(view: TransactionInfoView) {
        self.view = view
    }
}
