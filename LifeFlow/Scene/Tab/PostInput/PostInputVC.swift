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
