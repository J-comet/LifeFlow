//
//  PostDetailVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/07.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class PostDetailVC: BaseViewController<PostDetailView, PostDetailViewModel> {
    
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<PostDetailSectionModel>(
            configureCell: { (dataSource, collectionView, indexPath, item) in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCommentCell.identifier,
                for: indexPath
            ) as? PostCommentCell else { return UICollectionViewCell() }

                cell.configCell(row: item)
                cell.layoutIfNeeded()
                
            return cell
                
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            
            guard let self = self,
                  let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: PostHeaderView.identifier,
                for: indexPath
            ) as? PostHeaderView else { return UICollectionReusableView() }
            
            header.configCell(row: dataSource.sectionModels[indexPath.section].header)
            header.layoutIfNeeded()

//            header.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            
            return header
        })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
    }

}

extension PostDetailVC {
    
    func bindViewModel() {
        mainView.backButton
            .rx
            .tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: false)
            }            
            .disposed(by: viewModel.disposeBag)
        
        viewModel.collectionViewDataSource
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: viewModel.disposeBag)

    }
    
    func configureVC() {
        
    }
}
