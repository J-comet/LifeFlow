//
//  PostCreateRequest.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/01.
//

import Foundation

struct PostCreateRequest: Encodable {
    let product_id: String
    let title: String
    let content: String
    let date = Date()
}
