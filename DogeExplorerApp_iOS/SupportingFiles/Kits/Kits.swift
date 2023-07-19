//
//  ToastKit.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 18.07.2023.
//

import UIKit.UIApplication

enum AlertKit {
    static func presentToast(message: String) {
        let toast = ToastView(message: message)
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        toast.present(on: window)
    }
}
 
enum LoaderKit {
    static let loader = LoaderView()
    
    static func showLoader() {
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        loader.startLoading(on: window)
    }
    
    static func hideLoader() {
        loader.stopLoading()
    }
}
