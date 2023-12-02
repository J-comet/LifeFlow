//
//  Network.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/14.
//

import UIKit

import Alamofire
import RxSwift

final class Network {
    static let shared = Network()
    private init() { }
    
    static let commonErrorCode = 600
    
    func request<T: Decodable>(
        api: Router,
        type: T.Type
    ) -> Single<Result<T, NetworkError>> {
        return Single.create { single -> Disposable in
            AF.request(api)
                .validate()
                .responseDecodable(of: T.self) { response in
                    
                    var jsonString = "JSON 데이터 없음"
                    if let data = response.data {
                        jsonString = String(decoding: data, as: UTF8.self)
                    }
                    let statusCode = response.response?.statusCode ?? -1
                    let errorMessage = "<\(self)> : [JSONDecoder Error] code = \(statusCode)\njsonString = \(jsonString)"
                    
                    switch response.result {
                    case .success(let data):
                        if statusCode == 200 {
                            single(.success(.success(data)))
                        } else {
                            //                        let error = NSError(domain: errorMessage, code: statusCode)
                            let error = NetworkError(statusCode: statusCode)
                            single(.success(.failure(error)))
                        }
                        
                    case .failure(let _):
                        //                    let error = NSError(domain: errorMessage, code: statusCode)
                        let error = NetworkError(statusCode: statusCode)
                        single(.success(.failure(error)))
                    }
                }
            return Disposables.create()
        }
        
    }
    
    func createPost(api: Router, images: [UIImage]) {
        AF.upload(multipartFormData: { multipartData in

            //img 추가
            for imageData in images {
                
                if let resizedImage = imageData.resizeWithWidth(width: 500) {
                    if let image = resizedImage.jpegData(compressionQuality: 1) {
                        multipartData.append(image, withName: "file", fileName: "test.jpeg", mimeType: "image/jpeg")
                    }
                }
            }
            
            // 배열 처리
//            let keywords =  try! JSONSerialization.data(withJSONObject: model.keywords, options: .prettyPrinted)
//            multipartFormData.append(keywords, withName: "keywords")

        }, with: api)
        .validate()
        .responseData { response in
            guard let statusCode = response.response?.statusCode else { return }
            
            switch response.result {
            case .success(let success):
                if statusCode == 200 {
//                    single(.success(.success(data)))
                    print("게시물 등록 성공")
                    print(success)
                } else {
                    print("게시물 등록 성공했지만 실패 - \(statusCode)")
//                    let error = NetworkError(statusCode: statusCode)
//                    single(.success(.failure(error)))
                }
            case .failure(let failure):
                print("게시물 완전 실패 - \(failure)")
//                let error = NetworkError(statusCode: statusCode)
//                single(.success(.failure(error)))
            }
            
        }
    }
}
