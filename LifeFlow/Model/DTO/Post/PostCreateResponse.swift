//
//  PostCreateResponse.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/02.
//

import Foundation

struct PostCreateResponse: Decodable, CreatEntityProtocol {
    let image: [String]?
//    let hashTags: [String]
    let id: String?
    let creator: CreatorResponse?
    let time: String?
    
    enum CodingKeys: String, CodingKey {
        case image
//        case hashTags
        case id = "_id"
        case creator, time
    }
    
    func toEntity() -> PostCreateEntity {
        PostCreateEntity(
            image: image ?? [],
            id: id ?? "",
            creator: creator?.toEntity() ?? CreatorEntity(id: "", nick: ""),
            time: time ?? ""
        )
    }
}

