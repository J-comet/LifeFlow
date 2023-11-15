//
//  TokenAPI.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/15.
//

import Foundation

import Alamofire

enum TokenAPI {
    case refresh(request: RequestRefreshTokenModel)
}

extension TokenAPI: Router, URLRequestConvertible {
    
    var baseURL: URL {
        URL(string: APIManagement.baseURL)!
    }
    
    var path: String {
        switch self {
        case .refresh:
            "refresh"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .refresh:
                .get
        }
    }
    
    var headers: [String:String] {
        switch self {
        case .refresh(let request):
            [
                "Authorization": request.authorization,
                "Refresh": request.refresh,
                "SesacKey": APIManagement.key
            ]
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .refresh:
            nil
        }
    }
    
    // get = URLEncoding.default
    // post = JSONEncoding.default
    var encoding: ParameterEncoding? {
        switch self {
        case .refresh:
            URLEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = HTTPHeaders(headers)
        request.timeoutInterval = 10
        
        if let encoding = encoding {
            return try encoding.encode(request, with: parameters)
        }
        return request
    }
    
    
}
