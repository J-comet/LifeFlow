//
//  PostEntity.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/01.
//

import Foundation

struct PostCreateEntity {
    let image: [String]
//    let hashTags: [String]
    let id: String
    let creator: CreatorEntity
    let time: String
}
