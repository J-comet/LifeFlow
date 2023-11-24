//
//  TokenResponse.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/16.
//

import Foundation

struct TokenResponse: Decodable, CreatEntityProtocol {
    let token: String?
    
    func toEntity() -> TokenEntity {
        TokenEntity(token: token ?? "")
    }
}
