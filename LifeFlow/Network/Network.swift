//
//  Network.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/14.
//

import Foundation

import Alamofire
import RxSwift


final class Network {
    static let shared = Network()
    private init() { }
    
    static let defaultHttpHeaders = [
        "Content-Type": "application/json",
        "SesacKey": APIManagement.key
    ]
    
    func request<T: Decodable>(api: Router, type: T.Type) -> Single<Result<T, NetworkError>> {
        return Single.create { single in
            let request = AF.request(api)
                .validate(statusCode: 200...299)
                .responseData { response in
                    
                    // print용
                    var jsonString = "JSON 데이터 없음"
                    if let data = response.data {
                        jsonString = String(decoding: data, as: UTF8.self)
                    }
                    let code = response.response?.statusCode ?? -1
                    
                    switch response.result {
                    case .success(let success):
                        do {
                            let obj = try JSONDecoder().decode(T.self, from: success)
                            single(.success(.success(obj)))

                        } catch {
                            print("<\(self)> : [JSONDecoder Error] code = \(code)\njsonString = \(jsonString)")
                            single(.failure(CommonError.failDecode))
                        }
                        
                    case .failure:
                        
                        guard let data = response.data, let statusCode = response.response?.statusCode else {
                            single(.failure(CommonError.unknown))
                            return
                        }
                        
                        do {
                            print("<\(self)> : [Failure] code = \(code)\njsonString = \(jsonString)")
                            let apiError = try JSONDecoder().decode(ResponseAPIError.self, from: data)
                            print("<\(self)> : 에러메시지 = \(apiError.message)")
                            
                            switch api.self {
                            case is TokenAPI:
                                let errorCode = NetworkError.token(error: TokenError(rawValue: statusCode) ?? .unknown, message: apiError.message)
                                single(.failure(errorCode))

                            default:
                                let errorCode = NetworkError.common(error: CommonError(rawValue: statusCode) ?? .unknown, message: apiError.message)
                                single(.failure(errorCode))
                            }
                            
//                            if let errorCode = CommonError(rawValue: statusCode){
//                                let errorMessage = try JSONDecoder().decode(ResponseAPIError.self, from: data)
//                                print("에러메시지 = \(errorMessage)")
//                                single(.failure(errorCode))
//                            }
                            
                        } catch {
                            single(.failure(CommonError.failDecode))
                        }
                        
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
