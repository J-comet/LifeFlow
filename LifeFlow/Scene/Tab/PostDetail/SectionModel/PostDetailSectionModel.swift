//
//  PostDetailSectionModel.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/08.
//

import Foundation

import RxDataSources

struct PostDetailSectionModel {
    var header: PostEntity
    var items: [Item]
}

extension PostDetailSectionModel: SectionModelType {
    typealias Item = String
    
    // String -> 댓글 구조체로 추후 수정
    init(original: PostDetailSectionModel, items: [String]) {
        self = original
        self.items = items
    }
}
