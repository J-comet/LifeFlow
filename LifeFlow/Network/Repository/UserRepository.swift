//
//  UserRepository.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/14.
//

import Foundation

import RxSwift

protocol UserRepositoryProtocol {
    func login(email: String, password: String) -> Single<Result<ResponseLoginModel, NetworkError>>
    func join(email: String, password: String, nick: String) -> Single<Result<ResponseJoinModel, NetworkError>>
}

final class UserRepository: UserRepositoryProtocol {
    static let shared = UserRepository()
    private init() {}
    
    private let api = UserAPI.self
    
    func login(email: String, password: String) -> Single<Result<ResponseLoginModel, NetworkError>> {
        return Network.shared.request(
            api: api.login(request: RequestLoginModel(email: email, password: password)),
            type: ResponseLoginModel.self
        )
    }
    
    func join(email: String, password: String, nick: String) -> Single<Result<ResponseJoinModel, NetworkError>> {
        return Network.shared.request(
            api: api.join(request: RequestJoinModel(email: email, password: password, nick: nick)),
            type: ResponseJoinModel.self
        )
    }
}
