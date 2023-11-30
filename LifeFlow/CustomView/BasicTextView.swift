//
//  BasicTextView.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/30.
//

import UIKit

final class BasicTextView: UITextView {
    
    var placeHolder = ""
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        textColor = .systemGray4
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.main.cgColor
        font = UIFont(name: SpoqaHanSansNeoFonts.regular.rawValue, size: 16)!
        textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeHolder: String) {
        self.init(frame: .zero, textContainer: nil)
        self.placeHolder = placeHolder
        text = placeHolder
        delegate = self
    }
}

extension BasicTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .systemGray4 else { return }
        text = nil
        textColor = .text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeHolder
            textColor = .systemGray4
        }
    }
}
