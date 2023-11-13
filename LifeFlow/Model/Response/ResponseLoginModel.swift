//
//  ResponseLoginModel.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/13.
//

import Foundation

struct ResponseLoginModel: Decodable {
    let token: String
    let refreshToken: String
}
