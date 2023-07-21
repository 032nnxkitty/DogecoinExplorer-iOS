//
//  TransactionInfoViewModelImpl.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.07.2023.
//

import Foundation

final class TransactionInfoViewModelImpl: TransactionInfoViewModel {
    private var transactionInfoModel: TransactionInfoModel
    
    // MARK: - Init
    init(model: TransactionInfoModel) {
        self.transactionInfoModel = model
    }
    
    // MARK: - Protocol Methods & Properties
    var numberOfSections: Int {
        return TransactionListModel.allCases.count
    }
    
    func getNumberOfItems(in section: Int) -> Int {
        guard let section = TransactionListModel(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .details:
            return TransactionListModel.DetailsListSection.allCases.count
        case .inputs:
            return transactionInfoModel.transaction.inputs?.count ?? 0
        case .outputs:
            return transactionInfoModel.transaction.outputs?.count ?? 0
        }
    }
    
    func getTitleForSection(in section: Int) -> String? {
        guard let section = TransactionListModel(rawValue: section) else {
            return nil
        }
        return section.title
    }
    
    func configureDetailCell(at indexPath: IndexPath) -> (title: String, value: String) {
        guard let section = TransactionListModel.DetailsListSection(rawValue: indexPath.row) else {
            return ("...", "...")
        }
        
        let title = section.title
        var value: String
        
        switch section {
        case .hash:
            let hash = transactionInfoModel.transaction.hash
            value = hash ?? "..."
        case .confirmed:
            let confirmed = transactionInfoModel.transaction.time?.formatUnixTime()
            value = confirmed ?? "..."
        case .numberOfInputs:
            let inputsNumber = transactionInfoModel.transaction.inputsN ?? -1
            value = "\(inputsNumber)"
        case .totalIn:
            let totalIn = transactionInfoModel.transaction.inputsValue?.formatNumberString()
            value = totalIn ?? "..."
        case .numberOfOutputs:
            let outputsNumber = transactionInfoModel.transaction.outputsN ?? -1
            value = "\(outputsNumber)"
        case .totalOut:
            let totalOut = transactionInfoModel.transaction.outputsValue?.formatNumberString()
            value = totalOut ?? "..."
        case .size:
            let size = transactionInfoModel.transaction.size ?? -1
            value = "\(size) bytes"
        case .fee:
            let fee = transactionInfoModel.transaction.fee
            value = fee ?? "..." + " DOGE"
        case .confirmations:
            let confirmations = transactionInfoModel.transaction.confirmations ?? -1
            value = "\(confirmations)"
        }
        
        return (title, value)
    }
    
    func configureInputCell(at indexPath: IndexPath) -> (from: String, amount: String) {
        let currentInput = transactionInfoModel.transaction.inputs?[indexPath.row]
        let addressFrom = currentInput?.address ?? "..."
        let amount = currentInput?.value?.formatNumberString() ?? "..."
        return (addressFrom, amount)
    }
    
    func configureOutputCell(at indexPath: IndexPath) -> (to: String, amount: String) {
        let currentOutput = transactionInfoModel.transaction.outputs?[indexPath.row]
        let addressFrom = currentOutput?.address ?? "..."
        let amount = currentOutput?.value?.formatNumberString() ?? "..."
        return (addressFrom, amount)
    }
}
