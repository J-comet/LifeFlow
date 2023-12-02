//
//  LoginResponse.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/16.
//

import Foundation

struct LoginResponse: Decodable, CreatEntityProtocol {
    let _id: String?
    let token: String?
    let refreshToken: String?
    
    func toEntity() -> LoginEntity {
        LoginEntity(id: _id ?? "", token: token ?? "", refreshToken: refreshToken ?? "")
    }
}
