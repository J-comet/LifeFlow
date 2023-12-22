//
//  PostRepository.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/02.
//

import UIKit

import RxSwift

final class PostRepository {
    
    func create(
        productId: String,
        params: PostCreateRequest,
        images: [Data]
    ) -> Single<Result<PostEntity, PostCreateError>> {
        return Single.create { single in
            Network.shared.upload(
                api: PostAPI.create,
                type: PostResponse.self, 
                params: params.toEncodable,
                images: images
            ).subscribe { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .success(let value):
                        single(.success(.success(value.toEntity())))
                    case .failure(let error):
                        single(.success(.failure(PostCreateError(rawValue: error.statusCode) ?? .commonError)))
                    }
                case .failure:
                    single(.success(.failure(PostCreateError.commonError)))
                }
            }
        }
    }
    
    func getPosts(next: String) -> Single<Result<PostListEntity, PostGetError>> {
        return Single.create { single in
            Network.shared.request(
                api: PostAPI.getPosts(
                    request: PostGetRequest(
                        product_id: Constant.ProductID.post,
                        next: next,
                        limit: "5"
                    )
                ),
                type: PostListResponse.self
            ).subscribe { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .success(let value):
                        single(.success(.success(value.toEntity())))
                    case .failure(let error):
                        single(.success(.failure(PostGetError(rawValue: error.statusCode) ?? .commonError)))
                    }
                case .failure:
                    single(.success(.failure(PostGetError.commonError)))
                }
            }
        }
    }
    
    func deletePost(id: String) -> Single<Result<PostDeleteEntity, PostDeleteError>> {
        return Single.create { single in
            Network.shared.request(
                api: PostAPI.delete(request: PostDeleteRequest(id: id)),
                type: PostDeleteResponse.self
            ).subscribe { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .success(let value):
                        single(.success(.success(value.toEntity())))
                    case .failure(let error):
                        single(.success(.failure(PostDeleteError(rawValue: error.statusCode) ?? .commonError)))
                    }
                case .failure:
                    single(.success(.failure(PostDeleteError.commonError)))
                }
            }
        }
    }
    
    func edit(
        id: String,
        params: PostEditRequest,
        images: [Data]
    ) -> Single<Result<PostEntity, PostEditError>> {
        return Single.create { single in
            Network.shared.upload(
                api: PostAPI.edit(id: id),
                type: PostResponse.self,
                params: params.toEncodable,
                images: images
            ).subscribe { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .success(let value):
                        single(.success(.success(value.toEntity())))
                    case .failure(let error):
                        single(.success(.failure(PostEditError(rawValue: error.statusCode) ?? .commonError)))
                    }
                case .failure:
                    single(.success(.failure(PostEditError.commonError)))
                }
            }
        }
    }
    
    func like(id: String) -> Single<Result<PostLikeEntity, PostLikeError>> {
        return Single.create { single in
            Network.shared.request(
                api: PostAPI.like(id: id),
                type: PostLikeResponse.self
            ).subscribe { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .success(let value):
                        single(.success(.success(value.toEntity())))
                    case .failure(let error):
                        single(.success(.failure(PostLikeError(rawValue: error.statusCode) ?? .commonError)))
                    }
                case .failure:
                    single(.success(.failure(PostLikeError.commonError)))
                }
            }
        }
    }
    
    func getPostsByUser(id: String) -> Single<Result<PostListEntity, PostGetError>> {
        return Single.create { single in
            Network.shared.request(
                api: PostAPI.getPostsByUser(id: id),
                type: PostListResponse.self
            ).subscribe { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .success(let value):
                        single(.success(.success(value.toEntity())))
                    case .failure(let error):
                        single(.success(.failure(PostGetError(rawValue: error.statusCode) ?? .commonError)))
                    }
                case .failure:
                    single(.success(.failure(PostGetError.commonError)))
                }
            }
        }
    }
}

enum PostCreateError: Int, Error {
    case commonError = 600          // API 공통으로 받을 수 있는 응답코드 - Message 파싱해서 사용하기
    case badRequest = 400           // 잘못된 요청
    case unableToAuthenticate = 401   // 인증할 수 없는 토큰
    case forbidden = 403            // 허용되지 않은 접근
    case noPostsCreated = 410       // DB 서버 장애로 게시글이 저장되지 않았을 때
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

enum PostGetError: Int, Error {
    case commonError = 600          // API 공통으로 받을 수 있는 응답코드 - Message 파싱해서 사용하기
    case badRequest = 400           // 잘못된 요청
    case unableToAuthenticate = 401   // 인증할 수 없는 토큰
    case forbidden = 403            // 허용되지 않은 접근
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
        case .needRefresh:
            "토큰이 만료되었어요"
        }
    }
}

enum PostDeleteError: Int, Error {
    case commonError = 600           // API 공통으로 받을 수 있는 응답코드 - Message 파싱해서 사용하기
    case unableToAuthenticate = 401   // 인증할 수 없는 토큰
    case forbidden = 403             // 허용되지 않은 접근
    case alreadyDeleted = 410         // 이미 삭제된 게시글
    case needRefresh = 419            // 토큰이 만료됨 - 리프레시 필요
    case notOwner = 445              // 삭제 권한이 없습니다
    
    var message: String {
        switch self {
        case .commonError:
            "알 수 없는 오류가 발생했어요"
        case .unableToAuthenticate:
            "인증할 수 없는 토큰이에요"
        case .forbidden:
            "허용되지 않은 접근이에요"
        case .alreadyDeleted:
            "이미 삭제된 글이에요"
        case .needRefresh:
            "토큰이 만료되었어요"
        case .notOwner:
            "게시글 권한이 없어요"
        }
    }
}

enum PostEditError: Int, Error {
    case commonError = 600           // API 공통으로 받을 수 있는 응답코드 - Message 파싱해서 사용하기
    case unableToAuthenticate = 401   // 인증할 수 없는 토큰
    case forbidden = 403             // 허용되지 않은 접근
    case alreadyDeleted = 410         // 이미 삭제된 게시글
    case needRefresh = 419            // 토큰이 만료됨 - 리프레시 필요
    case notOwner = 445              // 삭제 권한이 없습니다
    
    var message: String {
        switch self {
        case .commonError:
            "알 수 없는 오류가 발생했어요"
        case .unableToAuthenticate:
            "인증할 수 없는 토큰이에요"
        case .forbidden:
            "허용되지 않은 접근이에요"
        case .alreadyDeleted:
            "이미 삭제된 글이에요"
        case .needRefresh:
            "토큰이 만료되었어요"
        case .notOwner:
            "게시글 권한이 없어요"
        }
    }
}

enum PostLikeError: Int, Error {
    case commonError = 600           // API 공통으로 받을 수 있는 응답코드 - Message 파싱해서 사용하기
    case unableToAuthenticate = 401   // 인증할 수 없는 토큰
    case forbidden = 403             // 허용되지 않은 접근
    case notFound = 410             // 게시글을 찾을 수 없어요.
    case needRefresh = 419            // 토큰이 만료됨 - 리프레시 필요
    
    var message: String {
        switch self {
        case .commonError:
            "알 수 없는 오류가 발생했어요"
        case .unableToAuthenticate:
            "인증할 수 없는 토큰이에요"
        case .forbidden:
            "허용되지 않은 접근이에요"
        case .notFound:
            "게시글을 찾을 수 없어요"
        case .needRefresh:
            "토큰이 만료되었어요"
        }
    }
}

