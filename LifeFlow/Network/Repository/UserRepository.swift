//
//  UserRepository.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/14.
//

import Foundation

import RxSwift

protocol UserRepositoryProtocol {
    func login(email: String, password: String) -> Single<NetworkResult<ResponseLoginModel>>
    func join(email: String, password: String, nick: String) -> Single<NetworkResult<ResponseJoinModel>>
}

final class UserRepository: UserRepositoryProtocol {
    static let shared = UserRepository()
    private init() {}
    
    func login(email: String, password: String) -> Single<NetworkResult<ResponseLoginModel>> {
        return UserService().login(email: email, password: password)
    }
    
    func join(email: String, password: String, nick: String) -> Single<NetworkResult<ResponseJoinModel>> {
        return UserService().join(email: email, password: password, nick: nick)
    }
}
