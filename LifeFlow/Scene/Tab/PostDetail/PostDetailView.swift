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
    
    lazy var editAction = UIAction(title: "수정") { _ in
        self.editHandler?()
    }
    
    lazy var removeAction = UIAction(title: "삭제") { _ in
        self.removeHandler?()
    }
    
    var removeHandler: (() -> Void)?
    
    var editHandler: (() -> Void)?
    
    
    lazy var moreButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "ellipsis")
        config.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .text
        $0.configuration = config
        
        let buttonMenu = UIMenu(title: "", children: [self.editAction, self.removeAction])
        $0.menu = buttonMenu
        $0.showsMenuAsPrimaryAction = true
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
        topView.addSubview(moreButton)
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
        
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
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
        let config = UICollectionViewCompositionalLayoutConfiguration()
//        config.interSectionSpacing = 16
//
        // 매개변수 sectionProvider, configuration
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            let groupHeight = NSCollectionLayoutDimension.estimated(60)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: groupHeight)
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = .init(top: 8, leading: 0, bottom: 0, trailing: 0)
            
            // header 설정
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(UIScreen.main.bounds.size.height * 0.5)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
//            sectionHeader.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            
            section.boundarySupplementaryItems = [sectionHeader]
            return section
            
        }, configuration: config)
        return layout
    }
    
}
