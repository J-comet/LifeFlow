//
//  CreatorResponse.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/02.
//

import Foundation

struct CreatorResponse: Decodable, CreatEntityProtocol {
    let id: String?
    let nick: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nick
    }
    
    func toEntity() -> CreatorEntity {
        CreatorEntity(id: id ?? "", nick: nick ?? "")
    }
}
