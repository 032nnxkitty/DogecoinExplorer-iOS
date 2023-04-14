//
//  AddressInfoViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

protocol AddressInfoView: AnyObject {
    
}

final class AddressInfoViewController: UIViewController {
    public var presenter: AddressInfoPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension AddressInfoViewController: AddressInfoView {
    
}
