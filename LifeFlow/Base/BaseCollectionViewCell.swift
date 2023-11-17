//
//  BaseCollectionViewCell.swift
//  MailplugAssignment
//
//  Created by 장혜성 on 2023/11/16.
//

import UIKit

class BaseCollectionViewCell<Model>: UICollectionViewCell, BaseCellProtocol {
    
    typealias T = Model
  
    override init(frame: CGRect) {
        super.init(frame: frame)
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
