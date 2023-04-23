//
//  SelfSizedTableView.swift
//  DogeExplorerApp
//
//  Created by Arseniy Zolotarev on 03.04.2023.
//

import UIKit

// MARK: - Self Sized TableView
final class SelfSizedTableView: UITableView {
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



