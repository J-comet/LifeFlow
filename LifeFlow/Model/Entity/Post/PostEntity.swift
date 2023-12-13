//
//  PostEntity.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/01.
//

import Foundation

struct PostEntity {
    var image: [String]
    let likes: [String]
    let id: String
    let creator: CreatorEntity
    var title: String
    var content: String
    var comments: [CommentEntity]
    let time: String
    var isExpand = false        // 더보기 레이블 확장 여부
    var currentImagePage = 0     // 현재 보고 있는 이미지 위치
    var date: String {
        return time.formattedDate()
    }
}
