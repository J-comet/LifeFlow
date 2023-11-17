//
//  BaseView.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/17.
//

import UIKit

class BaseView: UIView {

    var viewBackgroundColor: UIColor { .background }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = viewBackgroundColor
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
}
