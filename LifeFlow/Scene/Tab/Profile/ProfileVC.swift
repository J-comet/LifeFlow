//
//  ProfileVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/28.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

final class ProfileVC: BaseViewController<ProfileView, ProfileViewModel> {
    
    private let rightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "ellipsis")?.defaultIconStyle,
        style: .plain,
        target: nil,
        action: nil
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
        
        viewModel.fetchMyInfo()
    }
}

extension ProfileVC {
    
    func bindViewModel() {
        rightBarButton
            .rx
            .tap
            .bind(with: self) { owner, _ in
                print("설정")
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.myInfo
            .bind(with: self) { owner, entity in
                guard let entity else {
                    return
                }
                owner.mainView.emailLabel.text = entity.email
                owner.mainView.nicknameLabel.text = entity.nick
                owner.mainView.profileImageView.loadImage(from: entity.profile, placeHolderImage: UIImage().defaultUser)
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.postIds
            .bind(to: mainView.postCollectionView.rx.items(cellIdentifier: GridPostCell.identifier, cellType: GridPostCell.self)) { (row, element, cell) in
                cell.configCell(row: element)
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.isLoading
            .bind { isLoading in
                if isLoading {
                    LoadingIndicator.show()
                } else {
                    LoadingIndicator.hide()
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        
        viewModel.errorMessage
            .bind(with: self) { owner, message in
                print(message)
                owner.showToast(msg: message)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    func configureVC() {
        navigationItem.rightBarButtonItem = rightBarButton
        
    }
}
