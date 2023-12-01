//
//  PostInputVIew.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/29.
//

import UIKit

import SnapKit
import Then

final class PostInputView: BaseView {
    
    let closeButton = UIButton().then { view in
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        view.setImage(.xmark.withConfiguration(configuration).withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: $0.safeAreaInsets.bottom, right: 0)
    }
    
    let containerView = UIView()
    
    let topLabel = BasicLabel().then {
        $0.font(weight: .medium, size: 16)
        $0.text = "게시글 작성"
    }
    
    lazy var imgCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
        $0.register(PostInputImageCell.self, forCellWithReuseIdentifier: PostInputImageCell.identifier)
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = true
    }
    
    private let titleLabel = BasicLabel().then {
        $0.font(weight: .light, size: 14)
        $0.text = "제목"
    }
    
    let titleTextField = BasicTextField(placeholderText: "제목")
    
    private let contentLabel = BasicLabel().then {
        $0.font(weight: .light, size: 14)
        $0.text = "내용"
    }
    
    let contentTextview = BasicTextView(placeHolder: "내용을 입력해주세요")
    
    let completeButton = BasicButton(title: "작성 완료", bgColor: .main)
    
    override func configureHierarchy() {
        addSubview(closeButton)
        addSubview(topLabel)
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(imgCollectionView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(titleTextField)
        containerView.addSubview(contentLabel)
        containerView.addSubview(contentTextview)
        addSubview(completeButton)
    }
    
    override func configureLayout() {
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeButton)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(8)
            make.leading.equalToSuperview().inset(16)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(completeButton.snp.top).offset(-16)
        }
        
        containerView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalTo(self)
        }
        
        imgCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imgCollectionView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        contentTextview.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(300)
        }
        
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension PostInputView {
    
    func createLayout() -> UICollectionViewFlowLayout {
        // 비율 계산해서 디바이스 별로 UI 설정
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let size = CGSize(width: 100, height: 100)
        
        layout.scrollDirection = .horizontal
        layout.itemSize = size
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)  // 컨텐츠가 잘리지 않고 자연스럽게 표시되도록 여백설정
        layout.minimumLineSpacing = spacing         // 셀과셀 위 아래 최소 간격
        layout.minimumInteritemSpacing = spacing    // 셀과셀 좌 우 최소 간격
        return layout
    }
}
