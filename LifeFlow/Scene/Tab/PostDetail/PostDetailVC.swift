//
//  PostDetailVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/07.
//

import UIKit

import RxSwift
import RxCocoa

final class PostDetailVC: BaseViewController<PostDetailView, PostDetailViewModel> {
    
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
            .debug()
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: false)
            }            
            .disposed(by: viewModel.disposeBag)
        
        viewModel.postDetail
            .bind(with: self) { owner, postEntity in
            print(postEntity)
        }
            .disposed(by: viewModel.disposeBag)
    }
    
    func configureVC() {
        
    }
}
