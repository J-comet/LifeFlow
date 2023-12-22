//
//  GridPostCell.swift
//  LifeFlow
//
//  Created by 장혜성 on 12/22/23.
//

import UIKit

import Then
import SnapKit

final class GridPostCell: BaseCollectionViewCell<PostEntity> {
    
    private let thumbnailImageView = UIImageView().then {
        $0.backgroundColor = .systemGray5
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    override func configCell(row: PostEntity) {
        guard let image = row.image.first else {
            return
        }
        thumbnailImageView.loadImage(from: image)
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
