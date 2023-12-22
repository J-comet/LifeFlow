//
//  ProfileRepository.swift
//  LifeFlow
//
//  Created by 장혜성 on 12/22/23.
//

import Foundation

import RxSwift

final class ProfileRepository {
    
    func me() -> Single<Result<UserInfoEntity, UserInfoError>> {
        return Single.create { single in
            Network.shared.request(
                api: ProfileAPI.me,
                type: UserInfoResponse.self
            ).subscribe { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .success(let value):
                        single(.success(.success(value.toEntity())))
                    case .failure(let error):
                        print(error)
                        single(.success(.failure(UserInfoError(rawValue: error.statusCode) ?? .commonError)))
                    }
                case .failure(let _):
                    single(.success(.failure(UserInfoError.commonError)))
                }
            }
        }
    }
    
}

enum UserInfoError: Int, Error {
    case commonError = 600           // API 공통으로 받을 수 있는 응답코드 - Message 파싱해서 사용하기
    case unableToAuthenticate = 401   // 인증할 수 없는 토큰
    case forbidden = 403             // 허용되지 않은 접근
    case needRefresh = 419            // 토큰이 만료됨 - 리프레시 필요
    
    var message: String {
        switch self {
        case .commonError:
            "알 수 없는 오류가 발생했어요"
        case .unableToAuthenticate:
            "인증할 수 없는 토큰이에요"
        case .forbidden:
            "허용되지 않은 접근이에요"
        case .needRefresh:
            "토큰이 만료되었어요"
        }
    }
}
