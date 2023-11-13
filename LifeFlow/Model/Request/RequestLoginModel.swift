//
//  RequestLoginModel.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/13.
//

import Foundation

struct RequestLoginModel: Encodable {
    let email: String
    let password: String
}
