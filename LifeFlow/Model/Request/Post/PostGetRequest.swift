//
//  PostGetRequest.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/03.
//

import Foundation

struct PostGetRequest: Encodable {
    let product_id: String
    let next: String        // 처음엔 빈값 , 다음 페이지 불러올 때는 next_cursor 값 , 마지막 페이지일 경우에는 next_cursor = 0
    let limit: String    
}
