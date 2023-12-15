//
//  CommentAPI.swift
//  LifeFlow
//
//  Created by 장혜성 on 12/15/23.
//

import Foundation

import Alamofire

enum CommentAPI {
    case create(request: CommentCreateRequest)
}

extension CommentAPI: Router, URLRequestConvertible {
    
    var baseURL: URL {
        URL(string: APIManagement.baseURL)!
    }
    
    var path: String {
        switch self {
        case .create(let request):
            "post/\(request.id)/comment"
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
                "Content-Type": "application/json"
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
        
        if let encoding = encoding {
            return try encoding.encode(request, with: parameters)
        }
        return request
    }
    
}
