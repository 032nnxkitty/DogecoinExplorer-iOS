//
//  SettingsPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

protocol SettingsPresenter {
    init(view: SettingsView)
    func getNumberOfSection() -> Int
    func getNumberOfRows(in section: Int) -> Int
}

final class SettingsPresenterImp: SettingsPresenter {
    private weak var view: SettingsView?
    
    init(view: SettingsView) {
        self.view = view
    }
    
    func getNumberOfSection() -> Int {
        return 0
    }
    
    func getNumberOfRows(in section: Int) -> Int {
        return 0
    }
}
