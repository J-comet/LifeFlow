//
//  PostAPI.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/01.
//

import Foundation

import Alamofire

enum PostAPI {
    case create(request: PostCreateRequest)
}

extension PostAPI: Router, URLRequestConvertible {
    
    var baseURL: URL {
        URL(string: APIManagement.baseURL)!
    }
    
    var path: String {
        switch self {
        case .create:
            "post"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .create:
                .post
        }
    }
    
    var headers: [String:String] {
        switch self {
        case .create:
            [
                "Authorization": UserDefaults.token,
                "SesacKey": APIManagement.key,
                "Content-Type": "multipart/form-data"
            ]
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .create(let request):
            request.toEncodable
        }
    }
    
    // get = URLEncoding.default
    // post = JSONEncoding.default
    var encoding: ParameterEncoding? {
        switch self {
        case .create:
            JSONEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = HTTPHeaders(headers)
//        request.timeoutInterval = 10
        
//        for (key, value) in parameters {
//            MultipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//        }
        
        if let encoding = encoding {
            return try encoding.encode(request, with: parameters)
        }
        return request
    }
    
    
}
