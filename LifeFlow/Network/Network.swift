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
    
    func createPost(api: Router, images: [UIImage], request: PostCreateRequest) {
        AF.upload(multipartFormData: { multipartData in
            
            //body 추가
            for (key, value) in request.toEncodable {
                multipartData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            //img 추가
            for imageData in images {
                if let image = imageData.jpegData(compressionQuality: 0.7) {
                    multipartData.append(image, withName: "file", fileName: "test.jpeg", mimeType: "image/jpeg")
                }
            }
            
            // 배열 처리
//            let keywords =  try! JSONSerialization.data(withJSONObject: model.keywords, options: .prettyPrinted)
//            multipartFormData.append(keywords, withName: "keywords")

        }, with: api)
        .validate()
        .responseData { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch statusCode {
            case 200:
                print("게시물 등록 성공")
            default:
                print("게시물 등록 실패")
            }
        }
    }
    
    
    // MARK: - 게시물 작성 API 요청
    //    func requestPost(images: [UIImage], with model: AddPostRequest, completionHandler: @escaping () -> Void) {
    //        let url = serverUrl
    //        let header: HTTPHeaders = ["Content-Type": "multipart/form-data"]
    //
    //        AF.upload(multipartFormData: { multipartFormData in
    //            // 기본타입 처리
    //            multipartFormData.append(Data(model.location?.utf8 ?? "".utf8), withName: "loca")
    //            multipartFormData.append(Data(model.content?.utf8 ?? "".utf8), withName: "content")
    //            multipartFormData.append(Data(String(model.latitude ?? 0.0).utf8), withName: "latitude")
    //            multipartFormData.append(Data(String(model.longitude ?? 0.0).utf8), withName: "longitude")
    //
    //            // Date 처리
    //            multipartFormData.append(Data(model.time?.toString().utf8 ?? "".utf8), withName: "time")
    //
    //            for image in images {
    //                // UIImage 처리
    //                multipartFormData.append(image.jpegData(compressionQuality: 1) ?? Data(),
    //                                         withName: "file",
    //                                         fileName: "image.jpeg",
    //                                         mimeType: "image/jpeg")
    //            }
    //
    //            // 배열 처리
    //            let keywords =  try! JSONSerialization.data(withJSONObject: model.keywords, options: .prettyPrinted)
    //            multipartFormData.append(keywords, withName: "keywords")
    //
    //        }, to: url, method: .post, headers: header)
    //        .responseData { response in
    //            guard let statusCode = response.response?.statusCode else { return }
    //
    //            switch statusCode {
    //            case 200:
    //                print("게시물 등록 성공")
    //                completionHandler()
    //            default:
    //                print("게시물 등록 실패")
    //            }
    //        }
    //    }
    
    
//    func upload(image: Data, url: Router, params: [String: Any]) {
//        AF.upload(multipartFormData: { multiPart in
//            for (key, value) in params {
//                if let temp = value as? String {
//                    multiPart.append(temp.data(using: .utf8)!, withName: key)
//                }
//                if let temp = value as? Int {
//                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
//                }
//                if let temp = value as? NSArray {
//                    temp.forEach({ element in
//                        let keyObj = key + "[]"
//                        if let string = element as? String {
//                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
//                        } else
//                        if let num = element as? Int {
//                            let value = "\(num)"
//                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
//                        }
//                    })
//                }
//            }
//            multiPart.append(image, withName: "file", fileName: "file.png", mimeType: "image/png")
//        }, with: url)
//        
//        .uploadProgress(queue: .main, closure: { progress in
//            //Current upload progress of file
//            print("Upload Progress: \(progress.fractionCompleted)")
//        })
//        .responseJSON(completionHandler: { data in
//            //Do what ever you want to do with response
//        })
//    }
    
}
