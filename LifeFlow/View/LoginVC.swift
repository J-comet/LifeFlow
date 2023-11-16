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
        
        postTest()
//        getTest()
    }
    
    func postTest() {
        let id = "6555c4716d62650e9a728114"
        UserRepository.shared.join(email: "k111@k@.com", password: "1234", nick: "닉닉")
            .subscribe { result in
                switch result {
                case .success(let data):
                    print("11111")
                    print(data.id)
                case .failure(let error):
                    print("2222")
                    switch error {
                    case .common(let error, let message):
                        print(self," ",error)
                        print(message)
                    case .token(let error, let message):
                        print(self," ",error)
                        print(message)
                    }
                }
            } onFailure: { error in
                let networkError = error as! NetworkError
                switch networkError {
                case .common(let error, let message):
                    print("1234")
                    print(error)
                    print(message)
                case .token(let error, let message):
                    print("5678")
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
    
    func getTest() {
        let auth = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3MDAwNzA5OTgsImV4cCI6MTcwMDA3MTg5OCwiaXNzIjoic2VzYWNfMyJ9.bu_5zT8PdMN1oZjYhhJbbPlNckJHuIJwuZ42lotxzlk"
        let refresh = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NTE5NDRhNmQ2MjY1MGU5YTcyNmUyNiIsImlhdCI6MTcwMDA3MDk5OCwiZXhwIjoxNzAwMDcyNzk4LCJpc3MiOiJzZXNhY18zIn0.uPzQPz8OlJ0YMaFnDV6sdhOiR1T8Fd0A_0Gkzg31d4k"
        
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
//                    print(message)
                    
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
