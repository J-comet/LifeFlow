//
//  PostDeleteResponse.swift
//  LifeFlow
//
//  Created by 장혜성 on 12/13/23.
//

import Foundation

struct PostDeleteResponse: Decodable, CreatEntityProtocol {
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
    }
    
    func toEntity() -> PostDeleteEntity {
        PostDeleteEntity(id: id ?? "")
    }
}
