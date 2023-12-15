//
//  CommentCreateRequest.swift
//  LifeFlow
//
//  Created by 장혜성 on 12/15/23.
//

import Foundation

struct CommentCreateRequest: Encodable {
    let id: String
    let content: String
}
