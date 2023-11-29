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
    }
}


extension HomeVC {
    
    func bindViewModel() {
        let arrString = ["a","b","c","d"]
        Observable.just(arrString)
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.tableView.rx.items(cellIdentifier: HomeTableCell.identifier, cellType: HomeTableCell.self)) { (row, element, cell) in
                cell.configCell(row: element)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    func configureVC() {        
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.titleView = navTitleLabel
        navigationController?.hidesBarsOnSwipe = true
    }
}
