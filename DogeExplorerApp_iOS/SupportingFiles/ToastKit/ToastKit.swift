//
//  ToastKit.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 18.07.2023.
//

import UIKit.UIApplication

enum ToastKit {
    static func present(message: String) {
        let toast = ToastView(message: message)
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        toast.present(on: window)
    }
}
