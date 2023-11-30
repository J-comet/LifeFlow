//
//  PostInputVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/29.
//

import UIKit

import RxSwift
import RxCocoa

final class PostInputVC: BaseViewController<PostInputView, PostInputViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
    }
}

extension PostInputVC {
    
    func bindViewModel() {
        
        let arrString = ["none","none","none","none","none","none","none","none","none","none","none","none","none"]
        Observable.just(arrString)
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.imgCollectionView.rx.items(cellIdentifier: PostInputImageCell.identifier, cellType: PostInputImageCell.self)) { (row, element, cell) in
                
                cell.configCell(row: element)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    func configureVC() {
        mainView.closeButton
            .rx
            .tap
            .bind(with: self) { owner, _ in
                self.dismiss(animated: true)
            }
            .disposed(by: viewModel.disposeBag)
    }
}
