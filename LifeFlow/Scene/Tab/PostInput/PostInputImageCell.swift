//
//  PostInputImageCell.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/30.
//

import UIKit

import SnapKit
import Then

final class PostInputImageCell: BaseCollectionViewCell<String> {
    
    let plusView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    let plusImageView = UIImageView().then {
        $0.image = UIImage(systemName: "plus")?.withTintColor(.systemGray4, renderingMode: .alwaysOriginal)
    }
    
    
    override func configCell(row: String) {
        
    }
    
    override func configureHierarchy() {
        contentView.addSubview(plusView)
        plusView.addSubview(plusImageView)
    }
    
    override func configureLayout() {
        plusView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        plusImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
