//
//  MainViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

protocol MainView: AnyObject {
    
}

final class MainViewController: UIViewController {
    public var presenter: MainPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension MainViewController: MainView {
    
}
