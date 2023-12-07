//
//  PostDetailView.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/07.
//

import UIKit

import SnapKit
import Then

final class PostDetailView: BaseView {
    
    private let topView = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    
    let backButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "chevron.backward")
        config.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .text
        $0.configuration = config
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
        $0.register(
            PostHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PostHeaderView.identifier
        )
        $0.register(PostCommentCell.self, forCellWithReuseIdentifier: PostCommentCell.identifier)
    }
    
    override func configureHierarchy() {
        addSubview(topView)
        topView.addSubview(backButton)
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        topView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }
}

extension PostDetailView {

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width: CGFloat = UIScreen.main.bounds.width
        
        layout.itemSize = CGSize(width: width, height: 55)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)  // 컨텐츠가 잘리지 않고 자연스럽게 표시되도록 여백설정
        layout.minimumLineSpacing = 0         // 셀과셀 위 아래 최소 간격
        layout.minimumInteritemSpacing = 0    // 셀과셀 좌 우 최소 간격
        return layout
    }
    
}
