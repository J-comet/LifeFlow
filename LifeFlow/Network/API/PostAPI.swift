//
//  PostAPI.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/01.
//

import Foundation

import Alamofire

enum PostAPI {
    case create
    case getPosts(request: PostGetRequest)
    case delete(request: PostDeleteRequest)
    case edit(id: String)
    case like(id: String)
}

extension PostAPI: Router, URLRequestConvertible {
    
    var baseURL: URL {
        URL(string: APIManagement.baseURL)!
    }
    
    var path: String {
        switch self {
        case .create:
            "post"
        case .getPosts:
            "post"
        case .delete(let request):
            "post/\(request.id)"
        case .edit(let id):
            "post/\(id)"
        case .like(let id):
            "post/like/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .create:
                .post
        case .getPosts:
                .get
        case .delete:
                .delete
        case .edit:
                .put
        case .like:
                .post
        }
    }
    
    var headers: [String:String] {
        switch self {
        case .create, .edit:
            [
                "Authorization": UserDefaults.token,
                "SesacKey": APIManagement.key,
                "Content-Type": "multipart/form-data"
            ]
        case .getPosts, .delete, .like:
            [
                "Authorization": UserDefaults.token,
                "SesacKey": APIManagement.key,
                "Content-Type": "application/json"
            ]
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .create, .delete, .edit, .like:
            nil
        case .getPosts(let request):
            request.toEncodable
        }
    }
    
    // get = URLEncoding.default
    // post = 전달할 데이터 있을 때 : JSONEncoding.default
    var encoding: ParameterEncoding? {
        switch self {
        case .create:
            URLEncoding.default
        case .getPosts:
            URLEncoding.default
        case .delete:
            URLEncoding.default
        case .edit:
            URLEncoding.default
        case .like
            URLEncoding.default
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
