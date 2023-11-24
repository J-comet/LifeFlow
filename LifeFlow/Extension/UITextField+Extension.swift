//
//  UITextField+Extension.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/24.
//

import UIKit

extension UITextField {
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }

        return true
    }
}
