//
//  TokenRequest.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/16.
//

import Foundation

struct TokenRequest: Encodable {
    let authorization: String
    let refresh: String
}
