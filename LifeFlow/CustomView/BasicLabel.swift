//
//  BasicLabel.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/24.
//

import UIKit

final class BasicLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func font(weight: SpoqaHanSansNeoFonts, size: CGFloat) {
        font = UIFont(name: weight.rawValue, size: size)
    }
}
