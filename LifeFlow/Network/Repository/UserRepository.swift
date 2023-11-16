//
//  UserRepository.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/14.
//

import Foundation

import RxSwift


final class UserRepository {
    static let shared = UserRepository()
    private init() {}
    
//    private let api = UserAPI.self
    
    func login(email: String, password: String) -> Single<Result<LoginEntity, NetworkError>> {
        return Single.create { single in
            let request = Network.shared.request(
                api: UserAPI.login(request: LoginRequest(email: email, password: password)),
                type: LoginResponse.self
            )
                .subscribe { result in
                    switch result {
                    case .success(let response):
                        single(.success(.success(response.toEntity())))
                    case .failure(let error):
                        single(.failure(error))
                    }
                } onFailure: { error in
                    single(.failure(error))
                }
            return Disposables.create() {
                request.dispose()
            }
        }
    }
    
    func join(email: String, password: String, nick: String) -> Single<Result<JoinEntity, NetworkError>> {
        return Single.create { single in
            let request = Network.shared.request(
                api: UserAPI.join(request: JoinRequest(email: email, password: password, nick: nick)),
                type: JoinResponse.self
            )
                .subscribe { result in
                    switch result {
                    case .success(let response):
                        single(.success(.success(response.toEntity())))
                    case .failure(let error):
                        single(.failure(error))
                    }
                } onFailure: { error in
                    single(.failure(error))
                }
            return Disposables.create() {
                request.dispose()
            }
        }
    }
}
