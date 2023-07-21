//
//  UIViewController+TextFieldAlert.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 18.07.2023.
//

import UIKit

extension UIViewController {
    func presentTextFieldAlert(
        title: String?,
        message: String? = nil,
        placeHolder: String? = nil,
        textFieldText: String?,
        completion: @escaping (String?) -> Void
    ) {
        let renameAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        renameAlert.addTextField { textField in
            textField.placeholder = placeHolder
            textField.text = textFieldText
        }
        renameAlert.addAction(.init(title: "Cancel", style: .cancel))
        renameAlert.addAction(.init(title: "Confirm", style: .default) { _ in
            let text = renameAlert.textFields?[0].text
            completion(text)
        })
        present(renameAlert, animated: true)
    }
}
