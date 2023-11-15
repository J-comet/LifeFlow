//
//  TokenRepository.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/15.
//

import Foundation

import RxSwift

protocol TokenRepositoryProtocol {
    func refresh(authorization: String, refresh: String) -> Single<Result<TokenEntity, NetworkError>>
}

final class TokenRepository: TokenRepositoryProtocol {
    static let shared = TokenRepository()
    private init() {}
    
//    private let api = TokenAPI.self
    
//    func refresh(authorization: String, refresh: String) -> Single<Result<TokenResponse, NetworkError>> {
//        return Network.shared.request(
//            api: api.refresh(request: TokenRequest(authorization: authorization, refresh: refresh)),
//            type: TokenResponse.self
//        )
//    }

    func refresh(authorization: String, refresh: String) -> Single<Result<TokenEntity, NetworkError>> {
        return Single.create { single in
            let request = Network.shared.request(
                api: TokenAPI.refresh(request: TokenRequest(authorization: authorization, refresh: refresh)),
                type: TokenResponse.self
            )
                .subscribe { result in
                    switch result {
                    case .success(let response):
                        single(.success(.success(response.toTokenEntity())))
                    case .failure(let error):
                        single(.failure(error))
                    }
                } onFailure: { error in
                    single(.failure(error))
                }
            return Disposables.create()
        }
    }
    
}
