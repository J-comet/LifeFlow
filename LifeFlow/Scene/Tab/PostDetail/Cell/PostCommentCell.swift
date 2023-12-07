//
//  PostCommentCell.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/08.
//

import UIKit

import SnapKit
import Then

final class PostCommentCell: BaseCollectionViewCell<String> {
    
    let commentLabel = BasicLabel().then {
        $0.font(weight: .regular, size: 14)
        $0.textColor = .text
    }
    
    override func configCell(row: String) {
        commentLabel.text = row
    }
    
    override func configureHierarchy() {
        contentView.addSubview(commentLabel)
    }
    
    override func configureLayout() {
        commentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
