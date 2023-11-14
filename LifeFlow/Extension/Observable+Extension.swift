//
//  Observable+Extension.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/13.
//

import Foundation
import RxSwift
import Alamofire

// RxAlamofire 용 에러처리 방법 좀더 학습 필요
//extension Observable where Element == (HTTPURLResponse, Data) {
//    fileprivate func expectingObject<T : Codable>(ofType type: T.Type) -> Observable<ApiResult<T, ApiErrorMessage>> {
//        return self.map { (httpURLResponse, data) in
////            ApiResult<T, ApiErrorMessage> in
//            
//            switch httpURLResponse.statusCode{
//                
//            case 200 ... 299:
//                // is status code is successful we can safely decode to our expected type T
//                let object = try JSONDecoder().decode(type, from: data)
//                return .success(object)
//            default:
//                // otherwise try
//                let apiErrorMessage: ApiErrorMessage
//                do{
//                    // to decode an expected error
//                    apiErrorMessage = try JSONDecoder().decode(ApiErrorMessage.self, from: data)}
//                catch _ {
//                    // or not. (this occurs if the API failed or doesn't return a handled exception)
//                    apiErrorMessage = ApiErrorMessage(message: "Server Error.")
//                }
//                return .failure(apiErrorMessage)
//            }
//        }
//    }
//}
