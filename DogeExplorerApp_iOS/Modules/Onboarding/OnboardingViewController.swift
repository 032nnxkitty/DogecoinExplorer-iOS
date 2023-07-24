//
//  OnboardingViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 25.07.2023.
//

import UIKit

final class OnboardingViewController: UIViewController {
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.background
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .close, target: self, action: #selector(goToMain))
    }
    
    // MARK: - Private Methods
    @objc private func goToMain() {
        let vc = UINavigationController(rootViewController: Assembly.setupMainModule())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
