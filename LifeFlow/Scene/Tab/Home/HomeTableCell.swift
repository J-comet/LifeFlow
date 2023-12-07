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
    
    private let userThumbnail = UIImageView().then {
        $0.image = UIImage().defaultUser
    }
    
    private let nickNameLabel = BasicLabel().then {
        $0.font(weight: .medium, size: 14)
        $0.textColor = .text
    }
    
//    let menuButton = UIButton().then {
//        var config = UIButton.Configuration.filled()
//        config.image = UIImage(systemName: "ellipsis")!
//        config.baseBackgroundColor = .clear
//        config.baseForegroundColor = .text
//        $0.configuration = config
//    }
    
    private let titleLabel = BasicLabel().then {
        $0.font(weight: .medium, size: 14)
        $0.textColor = .text
    }
    
    // 확장레이블 + 기본레이블
    private let parentContentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
    }
    
    // 더보기 레이블용 ex) abcde ...더보기
    private let horizontalContentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 0
    }
    
    private let contentLabel = BasicLabel().then {
        $0.font(weight: .light, size: 14)
        $0.textColor = .text
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.lineBreakStrategy = .hangulWordPriority
    }
    
    private let expandContentLabel = BasicLabel().then {
        $0.font(weight: .light, size: 14)
        $0.textColor = .text
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
        $0.lineBreakStrategy = .hangulWordPriority
        $0.isHidden = true
    }
    
    let moreContentButton = UIButton().then {
        var attString = AttributedString(". . .더보기")
        attString.font = UIFont(name: SpoqaHanSansNeoFonts.light.rawValue, size: 14)!
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attString
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .lightGray
        $0.configuration = config
        $0.contentHorizontalAlignment = .left
    }
    
    lazy var horizontalImgCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = false
        $0.register(HomeImageCell.self, forCellWithReuseIdentifier: HomeImageCell.identifier)
        $0.isPagingEnabled = true
        $0.bounces = false
    }
    
    let bottonContainerView = UIView()
    
    private let horizontalImages = PublishRelay<[String]>()
    
    private let horizontalImageViewHeight = UIScreen.main.bounds.width * 1.2
    
    let currentPage = BehaviorRelay(value: 0)
    
    let heartView = UIImageView().then {
        $0.image = UIImage(systemName: "heart")?
            .withTintColor(.text, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(weight: .light))
    }
    
    let heartCntLabel = BasicLabel().then {
        $0.font(weight: .regular, size: 14)
        $0.textColor = .text
    }
    
    let commentView = UIImageView().then {
        $0.image = UIImage(systemName: "bubble.right")?
            .withTintColor(.text, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(weight: .light))
    }
    
    let pageControl = UIPageControl(frame: .zero).then {
        $0.pageIndicatorTintColor = .systemGray4
        $0.currentPageIndicatorTintColor = .darkGray
        $0.hidesForSinglePage = true
        $0.isUserInteractionEnabled = false
        $0.backgroundStyle = .minimal
        $0.isHidden = true
    }
    
    let dateLabel = BasicLabel().then {
        $0.font(weight: .light, size: 11)
        $0.textColor = .lightGray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bindHorizontalImages()
        bindPagingControl()
    }
    
    override func configCell(row: PostEntity) {
        horizontalImages.accept(row.image)
        pageControl.numberOfPages = row.image.count
        pageControl.currentPage = row.currentImagePage
        
        horizontalImgCollectionView.scrollToItem(at: .init(item: row.currentImagePage, section: 0), at: .centeredHorizontally, animated: false)
        
        userThumbnail.loadImage(
            from: "",
            placeHolderImage: UIImage().defaultUser
        )
        nickNameLabel.text = row.creator.nick
        heartCntLabel.text = "좋아요 \(row.likes.count)개"
        titleLabel.text = row.title
        contentLabel.text = row.content
        
        dateLabel.text = row.date
        expandContentLabel.isHidden = !row.isExpand
        horizontalContentStackView.isHidden = row.isExpand
        
        if expandContentLabel.getTextLines() > 1 {
            moreContentButton.isHidden = false
        } else {
            moreContentButton.isHidden = true
        }
    }
    
    private func bindHorizontalImages() {
        horizontalImages
            .asDriver(onErrorJustReturn: [])
            .drive(horizontalImgCollectionView.rx.items(cellIdentifier: HomeImageCell.identifier, cellType: HomeImageCell.self)) { (row, element, cell) in
                cell.configCell(row: element)
            }
            .disposed(by: disposeBag)
    }
    
    func bindPagingControl() {
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
    
    override func configureHierarchy() {
        contentView.addSubview(userThumbnail)
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(horizontalImgCollectionView)
        contentView.addSubview(bottonContainerView)
        bottonContainerView.addSubview(pageControl)
        bottonContainerView.addSubview(heartView)
        bottonContainerView.addSubview(commentView)
        bottonContainerView.addSubview(heartCntLabel)
        bottonContainerView.addSubview(titleLabel)
        bottonContainerView.addSubview(parentContentStackView)
        horizontalContentStackView.addArrangedSubview(contentLabel)
        horizontalContentStackView.addArrangedSubview(moreContentButton)

        contentLabel.setContentHuggingPriority(.required, for: .horizontal)
        moreContentButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        parentContentStackView.addArrangedSubview(expandContentLabel)
        parentContentStackView.addArrangedSubview(horizontalContentStackView)
        parentContentStackView.addArrangedSubview(dateLabel)
        
        bindHorizontalImages()
        bindPagingControl()
    }
    
    override func configureLayout() {
        userThumbnail.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(8)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userThumbnail)
            make.leading.equalTo(userThumbnail.snp.trailing).offset(8)
        }
        
        horizontalImgCollectionView.snp.makeConstraints { make in
            make.top.equalTo(userThumbnail.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(horizontalImageViewHeight)
        }
        
        bottonContainerView.snp.makeConstraints { make in
            make.top.equalTo(horizontalImgCollectionView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
        
        heartView.snp.makeConstraints { make in
            make.size.equalTo(28)
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalTo(pageControl)
        }
        
        heartCntLabel.snp.makeConstraints { make in
            make.top.equalTo(heartView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        commentView.snp.makeConstraints { make in
            make.size.equalTo(28)
            make.leading.equalTo(heartView.snp.trailing).offset(16)
            make.centerY.equalTo(heartView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(heartCntLabel.snp.bottom).offset(8)
            make.leading.equalTo(heartView)
        }
        
        parentContentStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        
        moreContentButton.snp.makeConstraints { make in
            make.leading.equalTo(contentLabel.snp.trailing)
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
        layout.sectionInset = .zero
        layout.minimumLineSpacing = spacing         // 셀과셀 위 아래 최소 간격
        layout.minimumInteritemSpacing = spacing    // 셀과셀 좌 우 최소 간격
        return layout
    }
    
    
}
