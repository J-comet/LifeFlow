//
//  PostListResponse.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/03.
//

import Foundation

struct PostListResponse: Decodable, CreatEntityProtocol {
    let data: [PostResponse]?
    let nextCursor: String?
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
    
    func toEntity() -> PostListEntity {
        PostListEntity(
            data: data?.map { $0.toEntity() } ?? [],
            nextCursor: nextCursor ?? ""
        )
    }
}
