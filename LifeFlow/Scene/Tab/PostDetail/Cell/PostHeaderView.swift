//
//  PostHeaderView.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/08.
//

import UIKit

import SnapKit
import Then
import Kingfisher

final class PostHeaderView: UICollectionReusableView, BaseCellProtocol {
    
    typealias T = PostEntity
    
    private let containerView = UIView().then {
        $0.backgroundColor = .red
    }
    
    private let imageContainerView = UIView().then {
        $0.backgroundColor = .blue
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        addSubview(containerView)
        addSubview(imageContainerView)
    }
    
    func configureLayout() {
        
        imageContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.snp.height).multipliedBy(0.76)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    func configCell(row item: PostEntity) {
        
    }
}


