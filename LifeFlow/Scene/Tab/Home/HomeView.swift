//
//  HomeView.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/28.
//

import UIKit

import SnapKit
import Then

final class HomeView: BaseView {
    
//    private let menuBottomSheetView = CommonBottomSheet().then {
//        $0.bottomSheetColor = .lightGray
//        $0.barViewColor = .darkGray
//    }
    
    let tableView = UITableView().then {
        $0.register(HomeTableCell.self, forCellReuseIdentifier: HomeTableCell.identifier)
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = false
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UIScreen.main.bounds.height
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    let emptyLabel = BasicLabel().then {
        $0.font(weight: .medium, size: 14)
        $0.textColor = .lightGray
        $0.text = "작성된 게시글이 없어요"
    }
    
    override func configureHierarchy() {
        addSubview(tableView)
        addSubview(emptyLabel)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
