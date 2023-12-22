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
        
        Observable.just(["1","3","4","5","6","7","8","9","1","2","3","4","5"])
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.postCollectionView.rx.items(cellIdentifier: GridPostCell.identifier, cellType: GridPostCell.self)) { (row, element, cell) in
                cell.configCell(row: element)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    func configureVC() {
        navigationItem.rightBarButtonItem = rightBarButton
        
    }
}
