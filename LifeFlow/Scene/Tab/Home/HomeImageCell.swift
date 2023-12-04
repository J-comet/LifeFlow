//
//  HomeImageCell.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/04.
//

import UIKit

import SnapKit
import Then
import Kingfisher
import RxSwift
import RxCocoa

final class HomeImageCell: BaseCollectionViewCell<String> {
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    override func configCell(row: String) {
        guard let url = URL(string: APIManagement.baseURL + row) else { return }
        imageView.kf.setImage(with: url)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
