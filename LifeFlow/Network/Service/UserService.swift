//
//  UserService.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/14.
//

import Foundation

import RxSwift

struct UserService {
    
//    func login(email: String, password: String) -> Observable<Result<ResponseLoginModel, NetworkError>> {
//            return Observable.create { observer -> Disposable in
//                
//                let event = Network.shared.request(
//                    api: UserAPI.login(
//                        request: RequestLoginModel(
//                            email: email,
//                            password: password)
//                    ),
//                    responseModel: ResponseLoginModel.self)
//                
//                
//                
//                
//                return Disposables.create()
////                AF.request(UserAPI.getMyProfile(sid: sid))
////                    .responseDecodable(of: BaseResponse<MyProfileData>.self) { response in
////                        print("[status code] \(response.response?.statusCode as Any)")
////                        
////                        switch response.result {
////                        case .success(let data):
////                            observer.onNext(.success(data))
////                        case .failure(let error):
////                            observer.onError(error)
////                        }
////                    }
////                
////                return Disposables.create()
//            }
//        }
}
