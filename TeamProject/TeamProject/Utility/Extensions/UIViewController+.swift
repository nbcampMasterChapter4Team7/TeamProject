//
//  UIViewController+.swift
//  TeamProject
//
//  Created by yimkeul on 4/30/25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default, handler: completion)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
