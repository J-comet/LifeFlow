//
//  RequestRefreshTokenModel.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/13.
//

import Foundation

struct RequestRefreshTokenModel: Encodable {
    let authorization: String
    let refresh: String
}
