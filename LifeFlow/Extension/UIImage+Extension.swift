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
    
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    var isAllowedFileSize: Bool {
        let maxSize = 10.0
        guard let bytes = self.pngData()?.count else {
            return false
        }
        let kb = Double(bytes) / 1000.0
        let mb = Double(kb) / 1000.0
        let currentImageSize = round(mb)

        if currentImageSize < maxSize {
            return true
        } else {
            return false
        }
    }
}
