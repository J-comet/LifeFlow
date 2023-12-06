//
//  UILabel+Extension.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/06.
//

import UIKit

extension UILabel {
    
    func getTextLines() -> Int {
        guard let text = self.text as NSString? else {
            return 0
        }
        guard let font = self.font else {
            return 0
        }
        
        var attributes = [NSAttributedString.Key: Any]()
        if let kernAttribute = self.attributedText?.attributes(at: 0, effectiveRange: nil).first(where: { key, _ in
            return key == .kern
        }) {
            attributes[.kern] = kernAttribute.value
        }
        attributes[.font] = font
        let labelTextSize = text.boundingRect(
            with: CGSize(width: self.bounds.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        return Int(ceil(labelTextSize.height / font.lineHeight))
    }
    
}
