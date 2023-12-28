//
//  AuthAPI.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/14.
//

import Foundation

import Alamofire

enum AuthAPI {
    case chkDuplicateEmail(request: DuplicateEmailRequest)     // 중복이메일 체크
    case join(request: JoinRequest)                         // 회원가입
    case login(request: LoginRequest)                       // 로그인
    case withdraw                                          // 회원탈퇴
}

extension AuthAPI: Router, URLRequestConvertible {
    
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
        case .withdraw:
            "withdraw"
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
        case .withdraw:
                .get
        }
    }
    
    var headers: [String:String] {
        switch self {
        case .chkDuplicateEmail, .join, .login:
            Constant.Network.defaultHttpHeaders
        case .withdraw:
            [
                "Authorization": UserDefaults.token,
                "SesacKey": APIManagement.key
            ]
        }
        
    }
    
    var parameters: [String: String]? {
        switch self {
        case .chkDuplicateEmail(let request):
            request.toEncodable
        case .join(let request):
            request.toEncodable
        case .login(let request):
            request.toEncodable
        case .withdraw:
            nil
        }
    }
    
    // get = URLEncoding.default
    // post = JSONEncoding.default
    var encoding: ParameterEncoding? {
        switch self {
        case .chkDuplicateEmail, .join, .login:
            JSONEncoding.default
        case .withdraw:
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
