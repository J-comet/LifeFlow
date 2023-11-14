//
//  Router.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/13.
//

import Foundation
import Alamofire


protocol Router: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: String]? { get }
    var encoding: ParameterEncoding? { get }
}

//enum Router: URLRequestConvertible {
//    
//    case refreshToken(request: RequestRefreshTokenModel)    // 리프레시 토큰
//    
//    case content(request: RequestContentModel)              // 컨텐츠 확인
//    
//    // 라우터 나눠서 관리..??
//    case join(request: RequestJoinModel)                    // 회원가입
//    case login(request: RequestLoginModel)                  // 로그인
//    
//    private var baseURL: URL {
//        URL(string: APIManagement.baseURL)!
//    }
//    
//    private var path: String {
//        switch self {
//        case .refreshToken:
//            return "refresh"
//        case .content:
//            return "content"
//        case .join:
//            return "join"
//        case .login:
//            return "login"
//        }
//    }
//    
//    private var method: HTTPMethod {
//        switch self {
//        case .refreshToken:
//            return .get
//        case .content:
//            return .get
//        case .join:
//            return .post
//        case .login:
//            return .post
//        }
//    }
//    
//    private var query: [String: String]? {
//        switch self {
//        case .refreshToken:
//            nil
//        case .content:
//            nil
//        case .join(let request):
//            request.toEncodable
//        case .login(let request):
//            request.toEncodable
//        }
//    }
//    
//    private var headers: HTTPHeaders {
//        switch self {
//        case .refreshToken(let request):
//            [
//                "Authorization": request.authorization,
//                "Refresh": request.refresh,
//                "SesacKey": APIManagement.key
//            ]
//        case .content(let request):
//            [
//                "Authorization": request.authorization,
//                "SesacKey": APIManagement.key
//            ]
//        case .join:
//            [
//                "Content-Type": "application/json",
//                "SesacKey": APIManagement.key
//            ]
//        case .login:
//            [
//                "Content-Type": "application/json",
//                "SesacKey": APIManagement.key
//            ]
//        }
//    }
//    
//    func asURLRequest() throws -> URLRequest {
//        let url = baseURL.appendingPathComponent(path)
//        var request = URLRequest(url: url)
//        request.method = method
//        request.headers = headers
////        request.setValue(APIManagement.key, forHTTPHeaderField: "SesacKey")
////        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.timeoutInterval = 10
//        
//        if method == HTTPMethod.get {
//            request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(query, into: request)
//        } else {
//            request = try JSONParameterEncoder.default.encode(query, into: request)
//        }
//        return request
//    }
//    
//}
