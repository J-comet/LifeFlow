//
//  CreatEntityProtocol.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/16.
//

import Foundation

protocol CreatEntityProtocol {
    associatedtype T
    
    func toEntity() -> T
        
}
