//
//  BasicTextField.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/17.
//

import UIKit

class BasicTextField: UITextField {
    
    init(placeholderText: String) {
        super.init(frame: .zero)
        textColor = .black
        borderStyle = .none
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.main.cgColor
        attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.systemGray4,
                NSAttributedString.Key.font : UIFont(name: SpoqaHanSansNeoFonts.regular.rawValue, size: 16)!
            ]
        )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var textPadding = UIEdgeInsets(
        top: 12,
        left: 16,
        bottom: 12,
        right: 16
    )
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}

