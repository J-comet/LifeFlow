//
//  GridPostCell.swift
//  LifeFlow
//
//  Created by 장혜성 on 12/22/23.
//

import UIKit

import Then
import SnapKit

final class GridPostCell: BaseCollectionViewCell<String> {
    
    private let thumbnailImageView = UIImageView().then {
        $0.backgroundColor = .systemGray5
    }
    
    override func configCell(row: String) {
        
    }
    
    override func configureHierarchy() {
        addSubview(thumbnailImageView)
    }
    
    override func configureLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
