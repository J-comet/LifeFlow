//
//  BaseCellProtocol.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/17.
//

import Foundation

protocol BaseCellProtocol {
    associatedtype T
    func configureHierarchy()
    func configureLayout()
    func configCell(row: T)
}
