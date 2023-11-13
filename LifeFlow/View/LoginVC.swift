//
//  LoginVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/13.
//

import UIKit

import RxSwift
import Alamofire
import RxAlamofire

enum APIError: Error {
    case invlidURL
    case unknown
    case statusError
}

final class LoginVC: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
        //        callRxGet()
        callRxLogin()
        //        callRxJoin()
    }
    
    func callRxGet() {
        
        // Login API 테스트 후에 token, refreshToken 테스트 가능
        RxAlamofire
            .requestJSON(
                Router.content(request: RequestContentModel(authorization: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NTFkNTQyNmQ2MjY1MGU5YTcyNmY1YiIsImlhdCI6MTY5OTg2MzkwMywiZXhwIjoxNjk5ODY1NzAzLCJpc3MiOiJzZXNhY18zIn0.-R65YpsjYTWgYZbTLzNdLdV_gCOUcjkTFP9Ur45XLSc"))
            )
            .subscribe { (response, data) in
                print(response.statusCode)
                print(data)
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func callRxLogin() {

        RxAlamofire
            .request(
                Router.login(request: RequestLoginModel(email: "aba@aaa.com", password: "123")), interceptor: nil
            )
            .data()
            .decode(type: ResponseLoginModel.self, decoder: JSONDecoder())
            .subscribe { response in
                print("1111")
                print(response)
            } onError: { error in
                print("2222")
                print(error)
            }
            .disposed(by: disposeBag)
        
        
        //        RxAlamofire
        //            .requestJSON(
        //                Router.login(
        //                    request: RequestLoginModel(email: "aba@aaa.com", password: "1234"))
        //            )
        //            .subscribe { (response, data) in
        //                print(response.statusCode)
        //                print(data)
        //            } onError: { error in
        //                print(error.localizedDescription)
        //            }
        //            .disposed(by: disposeBag)
    }
    
    func callRxJoin() {
        RxAlamofire
            .requestJSON(
                Router.join(
                    request:
                        RequestJoinModel(email: "aba@aaa.com",password: "1234", nick: "soso")
                )
            )
            .subscribe { (response, data) in
                print(response.statusCode)
                print(data)
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
}
