//
//  TokenResponse.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/16.
//

import Foundation

struct TokenResponse: Decodable {
    let token: String?
    
    func toTokenEntity() -> TokenEntity {
        TokenEntity(token: token ?? "")
    }
}
