//
//  PostLikeResponse.swift
//  LifeFlow
//
//  Created by 장혜성 on 12/17/23.
//

import Foundation

struct PostLikeResponse: Decodable, CreatEntityProtocol {
    let likeStatus: Bool?
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
    
    func toEntity() -> PostLikeEntity {
        PostLikeEntity(likeStatus: likeStatus ?? false)
    }
}
