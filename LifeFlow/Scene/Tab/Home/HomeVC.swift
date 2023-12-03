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
        
//        print(UserDefaults.token)
        viewModel.getPosts(next: "")
    }
}


extension HomeVC {
    
    func bindViewModel() {
        let arrString = ["a","b","c","d"]
        Observable.just(arrString)
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.tableView.rx.items(cellIdentifier: HomeTableCell.identifier, cellType: HomeTableCell.self)) { (row, element, cell) in
                cell.selectionStyle = .none
                cell.configCell(row: element)
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
        navigationController?.hidesBarsOnSwipe = true
    }
}
