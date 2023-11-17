//
//  BasicButton.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/17.
//

import UIKit

class BasicButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        backgroundColor = UIColor.black
        layer.cornerRadius = 10
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
