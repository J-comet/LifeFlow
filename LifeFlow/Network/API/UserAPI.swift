//
//  UserAPI.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/14.
//

import Foundation

import RxSwift
import Alamofire

enum UserAPI {
    case chkDuplicateEmail(request: DuplicateEmailRequest)   // 중복이메일 체크
    case join(request: JoinRequest)                         // 회원가입
    case login(request: LoginRequest)                       // 로그인
}

extension UserAPI: Router, URLRequestConvertible {
    
    var baseURL: URL {
        URL(string: APIManagement.baseURL)!
    }
    
    var path: String {
        switch self {
        case .chkDuplicateEmail:
            "validation/email"
        case .join:
            "join"
        case .login:
            "login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .chkDuplicateEmail:
                .post
        case .join:
                .post
        case .login:
                .post
        }
    }
    
    var headers: [String:String] {
        Constant.Network.defaultHttpHeaders
    }
    
    var parameters: [String: String]? {
        switch self {
        case .chkDuplicateEmail(let request):
            request.toEncodable
        case .join(let request):
            request.toEncodable
        case .login(let request):
            request.toEncodable
        }
    }
    
    // get = URLEncoding.default
    // post = JSONEncoding.default
    var encoding: ParameterEncoding? {
        switch self {
        case .chkDuplicateEmail:
            JSONEncoding.default
        case .join:
            JSONEncoding.default
        case .login:
            JSONEncoding.default
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
        
        //        if method == HTTPMethod.get {
        //            request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(parameters, into: request)
        //        } else {
        //            request = try JSONParameterEncoder.default.encode(parameters, into: request)
        //        }
        return request
    }
    
    
}
