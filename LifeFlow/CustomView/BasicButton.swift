//
//  BasicButton.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/17.
//

import UIKit

class BasicButton: UIButton {
    
    init(title: String, bgColor: UIColor? = .main) {
        super.init(frame: .zero)
        isExclusiveTouch = true
        clipsToBounds = true
        layer.cornerRadius = 10
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont(name: SpoqaHanSansNeoFonts.bold.rawValue, size: 16)!
        backgroundColor = bgColor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont(name: SpoqaHanSansNeoFonts.bold.rawValue, size: 16)!
    }
}
