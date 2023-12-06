//
//  PostResponse.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/02.
//

import Foundation

struct PostResponse: Decodable, CreatEntityProtocol {
    let image: [String]?
    let likes: [String]?
    let id: String?
    let creator: CreatorResponse?
    let title: String?
    let content: String?
    let time: String?
    
    enum CodingKeys: String, CodingKey {
        case image
        case likes
        case id = "_id"
        case creator, title, content, time
    }
    
    func toEntity() -> PostEntity {
        PostEntity(
            image: image ?? [], 
            likes: likes ?? [],
            id: id ?? "",
            creator: creator?.toEntity() ?? CreatorEntity(id: "", nick: "", profile: ""),
            title: title ?? "",
            content: content ?? "",
            time: time ?? ""
        )
    }
}

