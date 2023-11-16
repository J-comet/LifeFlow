//
//  JoinResponse.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/16.
//

import Foundation

struct JoinResponse: Decodable, CreatEntityProtocol {
    let id: String?
    let email: String?
    let nick: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email
        case nick
    }
    
    func toEntity() -> JoinEntity {
        JoinEntity(id: id ?? "", email: email ?? "", nick: nick ?? "")
    }
}
