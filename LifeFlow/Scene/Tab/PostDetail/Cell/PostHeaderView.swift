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
import RxSwift
import RxCocoa

final class PostHeaderView: UICollectionReusableView, BaseCellProtocol {
    
    typealias T = PostEntity
    
    var disposeBag = DisposeBag()
    
    private let horizontalImageViewHeight = UIScreen.main.bounds.width * 1.1
    
    private let containerView = UIView()
    
    private lazy var horizontalImgCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = false
        $0.register(HomeImageCell.self, forCellWithReuseIdentifier: HomeImageCell.identifier)
        $0.isPagingEnabled = true
        $0.bounces = false
    }
    
    private let horizontalImages = PublishRelay<[String]>()
    
//    private let imageContainerView = UIView().then {
//        $0.backgroundColor = .blue
//    }
    
    private let userContainerView = UIView()
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage().defaultUser
    }
    
    private let nicknameLabel = BasicLabel().then {
        $0.font(weight: .regular, size: 14)
        $0.textColor = .text
    }
    
    private let titleLabel = BasicLabel().then {
        $0.font(weight: .medium, size: 14)
        $0.textColor = .text
    }

    private let contentLabel = BasicLabel().then {
        $0.font(weight: .light, size: 14)
        $0.textColor = .text
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
        $0.lineBreakStrategy = .hangulWordPriority
    }
    
    private let commentGuideLabel = BasicLabel().then {
        $0.font(weight: .medium, size: 14)
        $0.textColor = .text
        $0.text = "댓글"
    }
    
    private let commentCntLabel = BasicLabel().then {
        $0.font(weight: .medium, size: 14)
        $0.textColor = .text
        $0.text = "0개"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bindHorizontalImages()
    }
    
    
    func configureHierarchy() {
        addSubview(containerView)
        addSubview(horizontalImgCollectionView)
        containerView.addSubview(userContainerView)
        userContainerView.addSubview(profileImageView)
        userContainerView.addSubview(nicknameLabel)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentLabel)
        containerView.addSubview(commentGuideLabel)
        containerView.addSubview(commentCntLabel)
        
        bindHorizontalImages()
    }
    
    private func bindHorizontalImages() {
        horizontalImages
            .asDriver(onErrorJustReturn: [])
            .drive(horizontalImgCollectionView.rx.items(cellIdentifier: HomeImageCell.identifier, cellType: HomeImageCell.self)) { (row, element, cell) in
                cell.configCell(row: element)
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        
        horizontalImgCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(horizontalImageViewHeight)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(horizontalImgCollectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()  // snapKit error 발생
        }
        
        userContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(64)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(userContainerView.snp.height).multipliedBy(0.7)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(userContainerView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        commentGuideLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        commentGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(16)
            make.leading.equalTo(16)
            make.bottom.lessThanOrEqualTo(containerView.snp.bottom)
        }
        
        commentCntLabel.snp.makeConstraints { make in
            make.centerY.equalTo(commentGuideLabel)
            make.leading.equalTo(commentGuideLabel.snp.trailing).offset(4)
        }
    }
    
    func configCell(row item: PostEntity) {
        horizontalImages.accept(item.image)
        profileImageView.loadImage(from: item.creator.profile, placeHolderImage: UIImage().defaultUser)
        nicknameLabel.text = item.creator.nick
        titleLabel.text = item.title
        contentLabel.text = item.content
        commentCntLabel.text = "\(item.comments.count)개"
    }
}

extension PostHeaderView {
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width: CGFloat = UIScreen.main.bounds.width // 디바이스 너비 계산
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: horizontalImageViewHeight)
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0         // 셀과셀 위 아래 최소 간격
        layout.minimumInteritemSpacing = 0    // 셀과셀 좌 우 최소 간격
        return layout
    }
    
}


