//
//  TitleSupplementaryView.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/07.
//

import UIKit

import SnapKit
import Then

class TitleSupplementaryView: UICollectionReusableView {
    
//    static let reuseIdentifier = "title-supplementary-reuse-identifier"
    
    let titleLabel = BasicLabel().then {
        $0.font(weight: .medium, size: 16)
        $0.textColor = .text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
