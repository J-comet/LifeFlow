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
                    
                    print(response.request?.url)
                    
                    var jsonString = "JSON 데이터 없음"
                    if let data = response.data {
                        jsonString = String(decoding: data, as: UTF8.self)
                    }
                    let statusCode = response.response?.statusCode ?? -1
                    let errorMessage = "<\(self)> : [JSONDecoder Error] code = \(statusCode)\njsonString = \(jsonString)"
                    
                    print("request = ", jsonString)
                    
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

    func upload<T: Decodable>(
        api: Router,
        type: T.Type,
        params: Parameters,
        images: [Data]
    ) -> Single<Result<T, NetworkError>> {
        return Single.create { single -> Disposable in
            AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in params {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                
                for (index, data) in images.enumerated() {
                    multipartFormData.append(
                        data,
                        withName: "file",
                        fileName: "\(Date().toString())/\(index).jpeg",
                        mimeType: "image/jpeg"
                    )
                }
            }, with: api)
            .validate()
            .responseDecodable(of: T.self) { response in
                
                guard let statusCode = response.response?.statusCode else { return }
                var jsonString = ""
                if let data = response.data {
                    jsonString = String(decoding: data, as: UTF8.self)
                }
                
                print("upload = ", jsonString)
                
                switch response.result {
                case .success(let data):
                    if statusCode == 200 {
                        single(.success(.success(data)))
                        print("게시물 등록 성공")
                    } else {
                        print("게시물 등록 성공할뻔 했지만 실패 - \(statusCode)")
                        let error = NetworkError(statusCode: statusCode)
                        single(.success(.failure(error)))
                    }
                case .failure(let failure):
                    print("게시물 완전 실패 - \(failure)")
                    let error = NetworkError(statusCode: statusCode)
                    single(.success(.failure(error)))
                }
                
            }
            return Disposables.create()
        }
        
    }
}
