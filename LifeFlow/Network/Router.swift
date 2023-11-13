//
//  Router.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/13.
//

import Foundation
import Alamofire


enum Router: URLRequestConvertible {
    
    case join(request: RequestJoinModel)
    
    private var baseURL: URL {
        switch self {
        case .join : URL(string: APIManagement.baseURL)!
        }
    }
    
    private var path: String {
        switch self {
        case .join:
            return "join"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .join:
            return .post
        }
    }
    
    private var query: [String: String] {
        switch self {
        case .join(let request):
            return request.toEncodable
        }
    }
    
    var headers: HTTPHeaders? {
        [
            "": "application/json",
            "SesacKey": APIManagement.key
        ]
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
//        request.headers = headers!
        request.setValue(APIManagement.key, forHTTPHeaderField: "SesacKey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        if method == HTTPMethod.get {
            request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(query, into: request)
        } else {
            request = try JSONParameterEncoder.default.encode(query, into: request)
        }
        
        return request
    }
    
}
