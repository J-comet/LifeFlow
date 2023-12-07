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
    
    private let leftBarButton = UIBarButtonItem(
        image: UIImage(systemName: "chevron.backward")!.defaultIconStyle,
        style: .plain,
        target: nil,
        action: nil
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
    }

}

extension PostDetailVC {
    
    func bindViewModel() {
        leftBarButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.postDetail
            .bind(with: self) { owner, postEntity in
            print(postEntity)
        }
            .disposed(by: viewModel.disposeBag)
    }
    
    func configureVC() {
        navigationItem.leftBarButtonItem = leftBarButton
    }
}
