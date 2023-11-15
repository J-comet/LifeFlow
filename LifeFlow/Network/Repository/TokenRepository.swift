//
//  TokenRepository.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/15.
//

import Foundation

import RxSwift

protocol TokenRepositoryProtocol {
    func refresh(authorization: String, refresh: String) -> Single<Result<ResponseRefreshTokenModel, NetworkError>>
}

final class TokenRepository: TokenRepositoryProtocol {
    static let shared = TokenRepository()
    private init() {}
    
    func refresh(authorization: String, refresh: String) -> Single<Result<ResponseRefreshTokenModel, NetworkError>> {
        return TokenService().refresh(authorization: authorization, refresh: refresh)
    }

}
