//
//  SettingsPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

protocol SettingsPresenter {
    init(view: SettingsView)
}

final class SettingsPresenterImp: SettingsPresenter {
    private weak var view: SettingsView?
    
    init(view: SettingsView) {
        self.view = view
    }
}
