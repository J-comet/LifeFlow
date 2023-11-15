//
//  Network.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/14.
//

import Foundation

import Alamofire
import RxSwift

//struct ErrorModel {
//    let code: Int
//    let message: String = ""
//    let jsonString: String = ""
//}
//
//enum NetworkResult<T> {
//    case success(data: T)
//    case error(errorData: ErrorModel)
//}

enum NetworkError: Int, Error {
    case unknown = 600
    case failDecode = 601           // JSONDecoder 오류 - 서버 구조체 파싱 실패했을 때
    
    case emptySesacKey = 420    // SesacKey 값 없음
    case overRequest = 429      // 과호출
    case abnormal = 444         // 비정상 호출
}

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
//                            observer.onNext()
//                            observer.onCompleted()
                        } catch {
                            print("[JSONDecoder Error] code = \(code)\njsonString = \(jsonString)")
                            single(.failure(NetworkError.failDecode))
                        }
                        
                    case .failure:
                        
                        guard let data = response.data, let statusCode = response.response?.statusCode else {
                            single(.failure(NetworkError.unknown))
                            return
                        }
                        
                        do {
                            print("[Failure] code = \(code)\njsonString = \(jsonString)")
                            if let errorCode = NetworkError(rawValue: statusCode){
                                let apiError = try JSONDecoder().decode(ResponseAPIError.self, from: data)
                                single(.failure(errorCode))
//                                single(.success(.error(code: errorCode, msg: apiError.message)))
                            }
                        } catch {
                            single(.failure(NetworkError.failDecode))
                        }
                        
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
