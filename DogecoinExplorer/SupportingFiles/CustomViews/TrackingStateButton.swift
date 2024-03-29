//
//  TrackingStateButton.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.05.2023.
//

import UIKit

final class TrackingStateButton: UIButton {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
        
        setNonTrackingState()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    var isTracked: Bool = false {
        didSet {
            isTracked ? setTrackingState() : setNonTrackingState()
        }
    }
    
    // MARK: - Private Methods
    private func configureAppearance() {
        configuration = UIButton.Configuration.filled()
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        configuration?.background.cornerRadius = 20
        configuration?.imagePadding = 5
    }
    
    private func setTrackingState() {
        setTitle("Delete tracking", for: .normal)
        setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        
        setTitleColor(.white, for: .normal)
        tintColor = .white
        
        configuration?.baseBackgroundColor = R.Colors.elementBackground
        configuration?.baseForegroundColor = .white
    }
    
    private func setNonTrackingState() {
        setTitle("Add tracking", for: .normal)
        setImage(UIImage(systemName: "eye.fill"), for: .normal)
        
        setTitleColor(.black, for: .normal)
        tintColor = .black
        
        configuration?.baseBackgroundColor = R.Colors.accent
        configuration?.baseForegroundColor = .black
    }
}
