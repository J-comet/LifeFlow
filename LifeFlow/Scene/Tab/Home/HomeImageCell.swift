//
//  HomeImageCell.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/04.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class HomeImageCell: BaseCollectionViewCell<String> {
    
    var disposeBag = DisposeBag()
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configCell(row: String) {
        imageView.loadImage(from: row)
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
