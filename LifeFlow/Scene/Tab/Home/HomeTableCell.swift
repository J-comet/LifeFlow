//
//  HomeTableCell.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/28.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class HomeTableCell: BaseTableViewCell<PostEntity> {
    
    var disposeBag = DisposeBag()
    
    let userThumbnail = UIImageView().then {
        $0.image = UIImage().defaultUser
    }
    
    let locNameLabel = UILabel()
    
    lazy var horizontalImgCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = false
        $0.register(HomeImageCell.self, forCellWithReuseIdentifier: HomeImageCell.identifier)
        $0.isPagingEnabled = true
        $0.bounces = false
    }
    
    let bottonContainerView = UIView()
    
    private let horizontalImages: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    private let horizontalImageViewHeight = UIScreen.main.bounds.width * 1.3
    
    private let currentPage = BehaviorRelay(value: 0)
    
    let pageControl = UIPageControl(frame: .zero).then {
        $0.pageIndicatorTintColor = .systemGray4
        $0.currentPageIndicatorTintColor = .darkGray
        $0.currentPage = 0
        $0.isUserInteractionEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bindHorizontalImages()
    }
    
    override func configCell(row: PostEntity) {
        pageControl.numberOfPages = row.image.count
        userThumbnail.loadImage(
            from: "",
            placeHolderImage: UIImage().defaultUser
        )
        locNameLabel.text = row.creator.nick
        horizontalImages.accept(row.image)
    }
    
    private func bindHorizontalImages() {
        horizontalImages
            .asDriver(onErrorJustReturn: [])
            .drive(horizontalImgCollectionView.rx.items(cellIdentifier: HomeImageCell.identifier, cellType: HomeImageCell.self)) { (row, element, cell) in
                cell.configCell(row: element)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(userThumbnail)
        contentView.addSubview(locNameLabel)
        contentView.addSubview(horizontalImgCollectionView)
        contentView.addSubview(bottonContainerView)
        bottonContainerView.addSubview(pageControl)
        
        bindHorizontalImages()
        
        horizontalImgCollectionView
            .rx
            .didEndDecelerating
            .bind(with: self) { owner, _ in
                let pageWidth = UIScreen.main.bounds.width
                let page = floor((owner.horizontalImgCollectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
                owner.currentPage.accept(Int(page))
            }
            .disposed(by: disposeBag)
        
        currentPage
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
    }
    
    override func configureLayout() {
        userThumbnail.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(8)
        }
        
        locNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userThumbnail)
            make.leading.equalTo(userThumbnail.snp.trailing).offset(8)
        }
        
        horizontalImgCollectionView.snp.makeConstraints { make in
            make.top.equalTo(userThumbnail.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(bottonContainerView.snp.top).offset(8)
            make.height.equalTo(horizontalImageViewHeight)
        }
        
        bottonContainerView.backgroundColor = .orange
        bottonContainerView.snp.makeConstraints { make in
            make.top.equalTo(horizontalImgCollectionView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}

extension HomeTableCell {
    
    func createLayout() -> UICollectionViewFlowLayout {
        // 비율 계산해서 디바이스 별로 UI 설정
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 0
        let width: CGFloat = UIScreen.main.bounds.width // 디바이스 너비 계산
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: horizontalImageViewHeight)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)  // 컨텐츠가 잘리지 않고 자연스럽게 표시되도록 여백설정
        layout.minimumLineSpacing = spacing         // 셀과셀 위 아래 최소 간격
        layout.minimumInteritemSpacing = spacing    // 셀과셀 좌 우 최소 간격
        return layout
    }
    
    
}
