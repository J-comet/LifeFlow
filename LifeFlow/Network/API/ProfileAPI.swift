//
//  ProfileAPI.swift
//  LifeFlow
//
//  Created by 장혜성 on 12/22/23.
//

import Foundation

import Alamofire

enum ProfileAPI {
    case me
}

extension ProfileAPI: Router, URLRequestConvertible {
    
    var baseURL: URL {
        URL(string: APIManagement.baseURL)!
    }
    
    var path: String {
        switch self {
        case .me:
            "profile/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .me:
                .get
        }
    }
    
    var headers: [String:String] {
        switch self {
        case .me:
            [
                "Authorization": UserDefaults.token,
                "SesacKey": APIManagement.key,
                "Content-Type": "application/json"
            ]
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .me:
            nil
        }
    }
    
    // get = URLEncoding.default
    // post = JSONEncoding.default
    var encoding: ParameterEncoding? {
        switch self {
        case .me:
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
