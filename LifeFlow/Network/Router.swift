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
