//
//  TokenRepository.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/15.
//

import Foundation

import RxSwift

final class TokenRepository {
    static let shared = TokenRepository()
    private init() {}
    
    func refresh(authorization: String, refresh: String) -> Single<Result<TokenEntity, Error>> {
        return Single.create { single in
            let request = Network.shared.singleRequest(
                api: TokenAPI.refresh(request: TokenRequest(authorization: authorization, refresh: refresh)),
                type: TokenResponse.self
            )
                .subscribe { result in
                    switch result {
                    case .success(let response):
                        single(.success(.success(response.toEntity())))
                    case .failure(let error):
                        single(.success(.failure(error)))
                    }
                }
            return Disposables.create() {
                request.dispose()
            }
        }
    }
}
