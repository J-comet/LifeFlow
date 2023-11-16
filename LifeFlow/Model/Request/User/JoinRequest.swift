//
//  JoinRequest.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/16.
//

import Foundation

struct JoinRequest: Encodable {
    let email: String
    let password: String
    let nick: String
}
