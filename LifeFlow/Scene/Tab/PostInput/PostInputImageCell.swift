//
//  PostInputImageCell.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/30.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class PostInputImageCell: BaseCollectionViewCell<PhpickerImage> {
    
    var disposeBag = DisposeBag()
    
    let plusView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    let plusImageView = UIImageView().then {
        $0.image = UIImage(systemName: "plus")?.withTintColor(.systemGray4, renderingMode: .alwaysOriginal)
    }
    
    let thumbView = UIView()
    
    let removeImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.backgroundColor = .white
        $0.image = UIImage(systemName: "xmark.circle.fill")
    }
    
    let thumbImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.contentMode = .scaleToFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configCell(row: PhpickerImage) {

        guard let _ = row.image else {
            plusView.isHidden = false
            thumbView.isHidden = true
            return
        }
        thumbImageView.image = row.image
        plusView.isHidden = true
        thumbView.isHidden = false
    }
    
    override func configureHierarchy() {
        contentView.addSubview(plusView)
        contentView.addSubview(thumbView)
        thumbView.addSubview(thumbImageView)
        thumbView.addSubview(removeImageView)
        plusView.addSubview(plusImageView)
    }
    
    override func configureLayout() {
        plusView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        plusImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        thumbView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        thumbImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        removeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(24)
        }

    }
}
