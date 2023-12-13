//
//  CommentResponse.swift
//  LifeFlow
//
//  Created by 장혜성 on 12/13/23.
//

import Foundation

struct CommentResponse: Decodable, CreatEntityProtocol {
    let id: String?
    let content: String?
    let creator: CreatorResponse?
    let time: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case content
        case creator
        case time
    }
    
    func toEntity() -> CommentEntity {
        CommentEntity(
            id: id ?? "",
            content: content ?? "",
            creator: creator?.toEntity() ?? CreatorEntity(id: "", nick: "", profile: ""),
            time: time ?? ""
        )
    }
}
