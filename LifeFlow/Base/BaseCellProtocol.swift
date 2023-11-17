//
//  BaseCellProtocol.swift
//  MailplugAssignment
//
//  Created by 장혜성 on 2023/11/16.
//

import Foundation

protocol BaseCellProtocol {
    associatedtype T
    func configureHierarchy()
    func configureLayout()
    func configCell(row: T)
}
