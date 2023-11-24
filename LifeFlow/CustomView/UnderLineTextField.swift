//
//  UnderLineTextField.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/24.
//

import UIKit

final class UnderLineTextField: UITextField, UITextFieldDelegate {
    
    private let border = CALayer()
    private let lineColor = UIColor.systemGray5
    private let lineHeight = 1.5
    
    init(placeholderText: String) {
        super.init(frame: .zero)
        textColor = .text
        borderStyle = .none
        attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.systemGray4,
                NSAttributedString.Key.font : UIFont(name: SpoqaHanSansNeoFonts.regular.rawValue, size: 16)!
            ]
        )
        
        border.borderColor = lineColor.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - lineHeight, width: frame.size.width, height: frame.size.height)
        border.borderWidth = 1.5
        layer.addSublayer(border)
        layer.masksToBounds = true
        
        delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        border.borderColor = UIColor.main.cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        border.borderColor = lineColor.cgColor
    }
}
