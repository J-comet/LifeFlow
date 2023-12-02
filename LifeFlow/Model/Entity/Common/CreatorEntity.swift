//
//  Creator.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/02.
//

import Foundation

struct CreatorEntity: Codable {
    let id, nick: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nick
    }
}
