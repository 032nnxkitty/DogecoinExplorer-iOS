//
//  SelfSizedTableView.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 17.05.2023.
//

import UIKit

class SelfSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
