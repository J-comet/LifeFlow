//
//  Network.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/14.
//

import Foundation

import Alamofire
import RxSwift

enum NetworkResult<T> {
    case success(data: T)
    case error(error: NetworkError, msg: String)
}

enum NetworkError: Int, Error {
    case failDecode = 600           // JSONDecoder 오류 - 서버 구조체 파싱 실패했을 때
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
    
    func request<T: Decodable>(api: Router, type: T.Type) -> Single<NetworkResult<T>> {
        return Single.create { single in            
            let request = AF.request(api)
                .validate(statusCode: 200...299)
                .responseData { response in
                switch response.result {
                case .success(let success):
                    
                    // test
                    let str = String(decoding: success, as: UTF8.self)
                    print("code = ", response.response?.statusCode)
                    print(str)
                    do {
                        let obj = try JSONDecoder().decode(T.self, from: success)
                        single(.success(.success(data: obj)))
                    } catch let error {
                        single(.failure(NetworkError.failDecode))
                    }
                    
                case .failure(let _):
                    if let data = response.data, let statusCode = response.response?.statusCode {
                        do {
                            if let networkError = NetworkError(rawValue: statusCode){
                                let apiError = try JSONDecoder().decode(ResponseAPIError.self, from: data)
                                single(.success(.error(error: networkError, msg: apiError.message)))
                            }
                        } catch let error {
                            single(.failure(NetworkError.failDecode))
                        }
                    }
                }
            }
            
            return Disposables.create {
              request.cancel()
            }
        }
    }
}
