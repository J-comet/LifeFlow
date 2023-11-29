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
    
    let tableView = UITableView().then {
        $0.register(HomeTableCell.self, forCellReuseIdentifier: HomeTableCell.identifier)
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = false
        $0.separatorStyle = .none
        $0.rowHeight = UIScreen.main.bounds.height * 0.8
    }
    
    override func configureHierarchy() {
        addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
}
