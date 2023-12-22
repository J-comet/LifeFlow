//
//  UserInfo.swift
//  LifeFlow
//
//  Created by 장혜성 on 12/22/23.
//

import Foundation

struct UserInfoResponse: Decodable, CreatEntityProtocol {
    let posts: [String]?
    let email: String?
    let nick: String?
    let profile: String?
    
    func toEntity() -> UserInfoEntity {
        UserInfoEntity(posts: posts ?? [], email: email ?? "", nick: nick ?? "", profile: profile ?? "")
    }
}
