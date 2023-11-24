//
//  UIViewController+Extension.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/24.
//

import UIKit

extension UIViewController {
    
    func showAlert(
        title: String,
        msg: String,
        ok: String,
        no: String? = nil,
        handler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: ok, style: .default, handler: handler)
        alert.addAction(okAction)
        if let no {
            let noAction = UIAlertAction(title: no, style: .cancel)
            alert.addAction(noAction)
        }
        present(alert, animated: true)
    }
    
}
