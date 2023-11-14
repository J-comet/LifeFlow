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
    case success(T)
    case error(NetworkError)
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
    
    func request<T: Decodable>(api: Router, type: T.Type) -> Single<NetworkResult<T>> {
        return Single.create { single in
//            let request22 = AF.request(api).responseJSON { response in
//                switch response.result {
//                case .success(let success):
//                    print(success)
//                    do {
//                        let obj = try JSONDecoder().decode(T.self, from: success as! Data)
//                        single(.success(.success(obj)))
//                    } catch let error {
//                        single(.failure(NetworkError.failDecode))
//                    }
//                case .failure(let failure):
//                    if let statusCode = response.response?.statusCode {
//                        if let networkError = NetworkError(rawValue: statusCode){
//                            single(.success(.error(networkError)))
//                        }
//                    }
//                }
//            }
            
            let request = AF.request(api).responseData { response in
                switch response.result {
                case .success(let success):
                    
                    let str = String(decoding: success, as: UTF8.self)
                    print("code = ", response.response?.statusCode)
                    print(str)
                    
                    do {
                        let obj = try JSONDecoder().decode(T.self, from: success)
                        single(.success(.success(obj)))
                    } catch let error {
                        single(.failure(NetworkError.failDecode))
                    }
                    
                case .failure(let _):
                    if let statusCode = response.response?.statusCode {
                        if let networkError = NetworkError(rawValue: statusCode){
                            single(.success(.error(networkError)))
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
