//
//  UserService.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/14.
//

import Foundation

import RxSwift

struct UserService {
    
    let api = UserAPI.self
    
    func login(email: String, password: String) -> Single<NetworkResult<ResponseLoginModel>> {
        return Network.shared.request(
            api: api.login(request: RequestLoginModel(email: email, password: password)),
            type: ResponseLoginModel.self
        )
    }
    
    func join(email: String, password: String, nick: String) -> Single<NetworkResult<ResponseJoinModel>> {
        return Network.shared.request(
            api: api.join(request: RequestJoinModel(email: email, password: password, nick: nick)),
            type: ResponseJoinModel.self
        )
    }
}
