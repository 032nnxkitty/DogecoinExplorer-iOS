//
//  LoaderSearchBar.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 19.05.2023.
//

import UIKit

class LoaderSearchBar: UISearchBar {
    private var leftView: UIView?
    private let loader = UIActivityIndicatorView()
    
    // MARK: - Public Methods
    func startAnimating() {
        leftView = self.searchTextField.leftView
        self.searchTextField.leftView = loader
        loader.startAnimating()
    }
    
    func stopAnimating() {
        loader.stopAnimating()
        self.searchTextField.leftView = leftView ?? UIImageView(image: UIImage(systemName: "magnifyingglass"))
        leftView = nil
    }
}
