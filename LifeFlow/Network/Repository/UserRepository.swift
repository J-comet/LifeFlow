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
    
    func login(email: String, password: String) -> Single<Result<ResponseLoginModel, NetworkError>> {
        return UserService().login(email: email, password: password)
    }
    
    func join(email: String, password: String, nick: String) -> Single<Result<ResponseJoinModel, NetworkError>> {
        return UserService().join(email: email, password: password, nick: nick)
    }
}
