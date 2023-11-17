//
//  ErrorMessage.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/14.
//

import Foundation

// 네트워크 에러 메시지는 DTO 처리 안하고 간단하게 optional 로 처리
struct ErrorResponse: Decodable {
    let message: String?
}
