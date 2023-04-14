//
//  SettingsViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

protocol SettingsView: AnyObject {
    
}

final class SettingsViewController: UIViewController {
    public var presenter: SettingsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension SettingsViewController: SettingsView {
    
}
