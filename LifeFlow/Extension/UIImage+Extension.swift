//
//  UIImage+Extension.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/28.
//

import UIKit

extension UIImage {
    var defaultIconStyle: UIImage {
        self.withTintColor(.black, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 18))
    }
}
