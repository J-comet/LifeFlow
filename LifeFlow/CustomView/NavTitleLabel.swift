//
//  NavTitleLabel.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/28.
//

import UIKit

final class NavTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width * 0.8, height: 44))
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        font = UIFont(name: SpoqaHanSansNeoFonts.bold.rawValue, size: 20)
        textColor = .main
        textAlignment = .left
    }
}
