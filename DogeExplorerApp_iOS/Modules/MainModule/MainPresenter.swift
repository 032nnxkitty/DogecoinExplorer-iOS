//
//  MainPresenter.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import Foundation

protocol MainPresenter {
    init(view: MainView)
    func settingsButtonDidTap()
}

final class MainPresenterImp: MainPresenter {
    private weak var view: MainView?
    
    init(view: MainView) {
        self.view = view
    }
    
    // MARK: - Public Methods
    func settingsButtonDidTap() {
        view?.showSettingsViewController()
    }
}
