//
//  ResponseLoginModel.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/13.
//

import Foundation

struct ResponseJoinModel: Decodable {
    let id: String
    let email: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email
        case nick
    }
}
