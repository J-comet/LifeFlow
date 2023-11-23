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
    
    func request<T: Decodable>(
        api: Router,
        type: T.Type,
        completion: @escaping (Result<T, Error>, Int) -> Void
    ) {
        AF.request(
            api
        ).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data), 200)
            case .failure(let error):
                let statusCode = response.response?.statusCode
                completion(.failure(error), statusCode ?? 600)
            }
        }
    }
    
    
//    func singleRequest<T: Decodable>(api: Router, type: T.Type) -> Single<Result<T, Error>> {
//        return Single.create { single in
//            let request = AF.request(api).validate(statusCode: 200...299).responseData { response in
//                
//                // 에러일 때 콘솔 확인용
//                var jsonString = "JSON 데이터 없음"
//                if let data = response.data {
//                    jsonString = String(decoding: data, as: UTF8.self)
//                }
//                let statusCode = response.response?.statusCode ?? -1
//                let errorMessage = "<\(self)> : [JSONDecoder Error] code = \(statusCode)\njsonString = \(jsonString)"
//
//                switch response.result {
//                case .success(let success):
//                    do {
//                        let obj = try JSONDecoder().decode(T.self, from: success)
//                        single(.success(.success(obj)))
//                    } catch {
//                        let error = NSError(domain: errorMessage, code: statusCode)
//                        single(.success(.failure(error)))
//                        print("JSON 파싱 오류 - \(errorMessage)")
//                    }
//                case .failure(let failure):
//                    guard let data = response.data else {
//                        let error = NSError(domain: "response.data = nil 로 옴", code: statusCode)
//                        single(.success(.failure(error)))
//                        return
//                    }
//                
//                    let obj = try? JSONDecoder().decode(ErrorResponse.self, from: data)
//                    let error = NSError(domain: obj?.message ?? "에러 내용 파싱 실패", code: statusCode)
//                    single(.success(.failure(error)))
//                }
//   
//            }
//            
//            return Disposables.create {
//                request.cancel()
//            }
//        }
//    }

}
