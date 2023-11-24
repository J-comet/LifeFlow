//
//  CommonMessageResponse.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/14.
//

import Foundation

// 공통으로 사용 : api 통신 결과값 message 만 있는 경우
struct CommonMessageResponse: Decodable {
    var message: String? = ""
}
