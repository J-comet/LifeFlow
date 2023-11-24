//
//  UserRepository.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/14.
//

import Foundation

import RxSwift


final class UserRepository {
    
    func login(email: String, password: String) -> Single<Result<LoginEntity, UserLoginError>> {
        return Single.create { single in
            Network.shared.request(
                api: UserAPI.login(request: LoginRequest(email: email, password: password)),
                type: LoginResponse.self
            ).subscribe { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .success(let value):
                        single(.success(.success(value.toEntity())))
                    case .failure(let error):
                        single(.success(.failure(UserLoginError(rawValue: error.statusCode) ?? .commonError)))
                    }
                case .failure(let _):
                    single(.success(.failure(UserLoginError.commonError)))
                }
            }
        }
    }
    
    func join(email: String, password: String, nick: String) -> Single<Result<JoinEntity, UserJoinError>> {
        return Single.create { single in
            Network.shared.request(
                api: UserAPI.join(request: JoinRequest(email: email, password: password, nick: nick)),
                type: JoinResponse.self
            ).subscribe { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .success(let value):
                        single(.success(.success(value.toEntity())))
                    case .failure(let error):
                        single(.success(.failure(UserJoinError(rawValue: error.statusCode) ?? .commonError)))
                    }
                case .failure(let _):
                    single(.success(.failure(UserJoinError.commonError)))
                }
            }
        }
    }
    
    func chkEmail(email: String) -> Single<Result<CommonMessageResponse, UserChkDuplicateEmailError>> {
        return Single.create { single in
            Network.shared.request(
                api: UserAPI.chkDuplicateEmail(request: DuplicateEmailRequest(email: email)),
                type: CommonMessageResponse.self
            ).subscribe { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .success(let value):
                        single(.success(.success(value)))
                    case .failure(let error):
                        single(.success(.failure(UserChkDuplicateEmailError(rawValue: error.statusCode) ?? .commonError)))
                    }
                case .failure(let _):
                    single(.success(.failure(UserChkDuplicateEmailError.commonError)))
                }
            }
        }
    }
}

enum UserLoginError: Int, Error {
    case commonError = 600          // API 공통으로 받을 수 있는 응답코드 - Message 파싱해서 사용하기
    case missingValue = 400         // 필수값 누락
    case notFoundAccount = 401       // 가입되지 않았거나, 이메일, 비밀번호 잘못 입력했을 때
    
    var message: String {
        switch self {
        case .commonError:
            "다시 시도해주세요"
        case .missingValue:
            "필수 정보가 누락되었어요"
        case .notFoundAccount:
            "이메일과 비밀번호를 확인해주세요"
        }
    }
}

enum UserJoinError: Int, Error {
    case commonError = 600          // API 공통으로 받을 수 있는 응답코드 - Message 파싱해서 사용하기
    case missingValue = 400         // 필수값 누락
    case existedUser = 409          // 존재하는 사용자
    
    var message: String {
        switch self {
        case .commonError:
            "다시 시도해주세요"
        case .missingValue:
            "필수 정보가 누락되었어요"
        case .existedUser:
            "이미 존재하는 사용자에요"
        }
    }
}

enum UserChkDuplicateEmailError: Int, Error {
    case commonError = 600          // API 공통으로 받을 수 있는 응답코드 - Message 파싱해서 사용하기
    case missingValue = 400         // 필수값 누락
    case notAvailable = 409         // 사용불가한 이메일
    
    var message: String {
        switch self {
        case .commonError:
            "다시 시도해주세요"
        case .missingValue:
            "필수 정보가 누락되었어요"
        case .notAvailable:
            "사용할 수 없는 이메일이에요"
        }
    }
}
