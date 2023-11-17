//
//  BaseTableViewCell.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/17.
//

import UIKit

class BaseTableViewCell<Model>: UITableViewCell, BaseCellProtocol {
    typealias T = Model
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureHierarchy() {}
    
    func configureLayout() {}
    
    func configCell(row: T) {}
}
