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
        
//        postTest()
        getTest()
        
        //        callRxGet()
        //        callRxLogin()
        //        callRxJoin()
    }
    
    func postTest() {
        UserRepository.shared.login(email: "hs@sesac.com", password: "1234")
            .subscribe { result in
                switch result {
                case .success(let data):
                    print(data.refreshToken)
                    print(data.token)
                case .failure(let error):
                    print(error)
                }
            } onFailure: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    func getTest() {
        let auth = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3MDAwNjYzMzEsImV4cCI6MTcwMDA2NzIzMSwiaXNzIjoic2VzYWNfMyJ9.dXtY1OyrjHU8K04lQA5z-DvX1q5iz0cFWyTdFel6NH4"
        let refresh = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NTE5NDRhNmQ2MjY1MGU5YTcyNmUyNiIsImlhdCI6MTcwMDA2NjMzMSwiZXhwIjoxNzAwMDY4MTMxLCJpc3MiOiJzZXNhY18zIn0.X3ab67dg1JEsEI8jN8sXRkUVJlaJQaW7AepbwS6EtQ4"
        
        TokenRepository.shared.refresh(authorization: auth, refresh: refresh)
            .subscribe { result in
                switch result {
                case .success(let data):
                    print("3333")
                    print(data)
                    
                    // Single 대신 Observarble 을 사용하게 된다면 직접 Completed 안시켜주면 버튼 누를때마다 구독되어 중첩됨
//                    observer.onNext()
//                    observer.onCompleted()
                    
                case .failure(let error):
                    print("11111")
                    print(error)
                }
            } onFailure: { error in
                let networkError = error as! NetworkError
                switch networkError {
                case .common(let error, let message):
                    print(error)
                    print(message)
                case .token(let error, let message):
                    print(error)
                    print(message)
                    
                    switch error {
                    case .unknown, .unableToAuthenticate, 
                            .forbidden, .server:
                        print(error.showMessage)
                    case .notExpire:
                        print("API 계속 진행시키기")
                    case .needRefresh:
                        print("토큰 리프레시 필요")
                    }
                }
            }
            .disposed(by: disposeBag)
    }

    
}
