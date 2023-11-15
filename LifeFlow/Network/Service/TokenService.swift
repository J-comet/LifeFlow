//
//  TokenService.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/15.
//

import Foundation

import RxSwift

struct TokenService {
    
    private let api = TokenAPI.self
    
    func refresh(authorization: String, refresh: String) -> Single<Result<ResponseRefreshTokenModel, NetworkError>> {
        return Network.shared.request(
            api: api.refresh(request: RequestRefreshTokenModel(authorization: authorization, refresh: refresh)),
            type: ResponseRefreshTokenModel.self
        )
    }
}
