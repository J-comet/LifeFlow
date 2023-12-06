//
//  HomeVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/28.
//

import UIKit

import RxSwift
import RxCocoa
import Then

final class HomeVC: BaseViewController<HomeView, HomeViewModel> {
    
    private let navTitleLabel = NavTitleLabel().then {
        $0.text = "Life Flow"
    }
    
    private let rightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "heart")?.defaultIconStyle,
        style: .plain,
        target: nil,
        action: nil
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
        
        print(UserDefaults.token)
        viewModel.getPosts()
    }
}


extension HomeVC {
    
    func bindViewModel() {
        
        viewModel.posts
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.tableView.rx.items(cellIdentifier: HomeTableCell.identifier, cellType: HomeTableCell.self)) { (row, element, cell) in
                cell.selectionStyle = .none
                cell.configCell(row: element)
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.posts
            .map { $0.isEmpty }
            .share()
            .bind(to: mainView.tableView.rx.isHidden)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.posts
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
            .drive(mainView.emptyLabel.rx.isHidden)
            .disposed(by: viewModel.disposeBag)
        
//        viewModel.posts
//            .map { $0.isEmpty }
//            .asDriver(onErrorJustReturn: false)
//            .drive(with: self) { owner, isEmpty in
//                owner.navigationController?.hidesBarsOnSwipe = !isEmpty
//            }
//            .disposed(by: viewModel.disposeBag)
        
        
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
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.titleView = navTitleLabel
        
    }
}
