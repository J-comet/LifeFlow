//
//  CommentRepository.swift
//  LifeFlow
//
//  Created by 장혜성 on 12/15/23.
//

import Foundation

import RxSwift

final class CommentRepository {
    
    func create(id: String, content: String) -> Single<Result<CommentEntity, CommentCreateError>> {
        return Single.create { single in
            Network.shared.request(
                api: CommentAPI.create(request: CommentCreateRequest(id: id, content: content)),
                type: CommentResponse.self
            ).subscribe { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .success(let value):
                        single(.success(.success(value.toEntity())))
                    case .failure(let error):
                        single(.success(.failure(CommentCreateError(rawValue: error.statusCode) ?? .commonError)))
                    }
                case .failure:
                    single(.success(.failure(CommentCreateError.commonError)))
                }
            }
        }
    }

}

enum CommentCreateError: Int, Error {
    case commonError = 600          // API 공통으로 받을 수 있는 응답코드 - Message 파싱해서 사용하기
    case badRequest = 400           // 잘못된 요청
    case unableToAuthenticate = 401   // 인증할 수 없는 토큰
    case forbidden = 403            // 허용되지 않은 접근
    case noPostsCreated = 410       // DB 서버 장애로 댓글 저장되지 않았을 때
    case needRefresh = 419          // 토큰이 만료됨 - 리프레시 필요
    
    var message: String {
        switch self {
        case .commonError:
            "알 수 없는 오류가 발생했어요"
        case .badRequest:
            "잘못된 요청이에요"
        case .unableToAuthenticate:
            "인증할 수 없는 토큰이에요"
        case .forbidden:
            "허용되지 않은 접근이에요"
        case .noPostsCreated:
            "관리자에게 문의해주세요"
        case .needRefresh:
            "토큰이 만료되었어요"
        }
    }
}

