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
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
        $0.register(
            PostHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PostHeaderView.identifier
        )
        $0.register(PostCommentCell.self, forCellWithReuseIdentifier: PostCommentCell.identifier)
    }
    
    override func configureHierarchy() {
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide)
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
