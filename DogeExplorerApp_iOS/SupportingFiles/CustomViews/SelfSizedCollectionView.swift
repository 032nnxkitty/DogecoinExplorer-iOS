//
//  SelfSizedCollectionView.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.05.2023.
//

import UIKit

class SelfSizedCollectionView: UICollectionView {
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
