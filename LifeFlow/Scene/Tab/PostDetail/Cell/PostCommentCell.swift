//
//  PostCommentCell.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/08.
//

import UIKit

import SnapKit
import Then

final class PostCommentCell: BaseCollectionViewCell<CommentEntity> {
    
    private let commentLabel = BasicLabel().then {
        $0.font(weight: .regular, size: 12)
        $0.textColor = .text
    }
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage().defaultUser
    }
    
    private let nicknameLabel = BasicLabel().then {
        $0.font(weight: .regular, size: 12)
        $0.textColor = .text
    }
    
    override func configCell(row: CommentEntity) {
        commentLabel.text = row.content
        nicknameLabel.text = row.creator.nick
        profileImageView.loadImage(from: row.creator.profile, placeHolderImage: UIImage().defaultUser)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(commentLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.centerY.equalTo(profileImageView)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}
