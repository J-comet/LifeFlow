//
//  NetworkErrorType.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/16.
//

import Foundation

enum NetworkError: Error {
    case common(error: CommonError, message: String)
    case token(error: TokenError, message: String)
}

enum CommonError: Int, Error {
    case unknown = 600
    case failDecode = 601           // JSONDecoder 오류 - 서버 구조체 파싱 실패했을 때
    case emptySesacKey = 420    // SesacKey 값 없음
    case overRequest = 429      // 과호출
    case abnormal = 444         // 비정상 호출
}

enum UserJoinError: Int, Error {
    case missingRequiredValue = 400  // 필수값 누락
    case existedUser = 409          // 존재하는 사용자
    case server = 500              // 서버 에러
}

enum TokenError: Int, Error {
    case unknown = 600
    case unableToAuthenticate = 401   // 인증할 수 없는 토큰
    case forbidden = 403            // 허용되지 않은 접근
    case notExpire = 409            // 토큰 만료되지 않음
    case needRefresh = 418          // 토큰이 만료됨 - 리프레시 필요
    case server = 500               // 서버 에러
    
    var showMessage: String {
        switch self {
        case .unknown:
            "알 수 없는 오류가 발생했어요"
        case .unableToAuthenticate:
            "인증할 수 없는 토큰이에요"
        case .forbidden:
            "허용되지 않은 접근이에요"
        case .notExpire:
            "토큰이 만료되지 않았어요"
        case .needRefresh:
            "토큰이 만료되었어요"
        case .server:
            "관리자에게 문의해주세요"
        }
    }
}
