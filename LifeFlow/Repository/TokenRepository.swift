//
//  TokenRepository.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/15.
//

import Foundation

import RxSwift

final class TokenRepository {
    
    func refresh(authorization: String, refresh: String) -> Single<Result<TokenEntity, TokenError>> {
        return Single.create { single in
            Network.shared.request(
                api: TokenAPI.refresh(request: TokenRequest(authorization: authorization, refresh: refresh)),
                type: TokenResponse.self
            ).subscribe { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .success(let value):
                        single(.success(.success(value.toEntity())))
                    case .failure(let error):
                        single(.success(.failure(TokenError(rawValue: error.statusCode) ?? .commonError)))
                    }
                case .failure(let _):
                    single(.success(.failure(TokenError.commonError)))
                }
            }
        }
    }
}

enum TokenError: Int, Error {
    case commonError = 600          // API 공통으로 받을 수 있는 응답코드 - Message 파싱해서 사용하기
    case unableToAuthenticate = 401   // 인증할 수 없는 토큰
    case forbidden = 403            // 허용되지 않은 접근
    case notExpire = 409            // 토큰 만료되지 않음
    case needLoginAgain = 418        // 리프레시토큰이 만료됨 - 다시로그인
    
    var message: String {
        switch self {
        case .commonError:
            "알 수 없는 오류가 발생했어요"
        case .unableToAuthenticate:
            "인증할 수 없는 토큰이에요"
        case .forbidden:
            "허용되지 않은 접근이에요"
        case .notExpire:
            "토큰이 만료되지 않았어요"
        case .needLoginAgain:
            "다시 로그인 해주세요"
        }
    }
}
