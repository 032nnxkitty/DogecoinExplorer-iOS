//
//  TrackingStateButton.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.05.2023.
//

import UIKit

class TrackingStateButton: UIButton {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    // MARK: - Public Methods
    func setTrackingState() {
        setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        setTitle(" Delete tracking", for: .normal)
        setTitleColor(.white, for: .normal)
        
        backgroundColor = R.Colors.backgroundGray
        tintColor = .label
    }
    
    func setNonTrackingState() {
        setTitle(" Add tracking", for: .normal)
        setImage(UIImage(systemName: "eye.fill"), for: .normal)
        setTitleColor(.black, for: .normal)
        
        backgroundColor = R.Colors.accent
        tintColor = .black
    }
    
    // MARK: - Private Methods
    private func configureAppearance() {
        backgroundColor = R.Colors.backgroundGray
        layer.cornerRadius = 20
        setTitle("Load more", for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .dogeSans(size: 17, style: .body)
        contentEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
}
