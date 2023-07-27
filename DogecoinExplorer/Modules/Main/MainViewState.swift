//
//  MainViewStates.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.07.2023.
//

import Foundation

enum MainViewState {
    case initial
    
    case emptyList
    
    case filledList
    
    case startLoader
    
    case finishLoader
    
    case message(text: String)
    
    case push(model: AddressInfoModel)
}
