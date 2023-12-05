//
//  BaseInterceptor.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/05.
//

import UIKit

import Alamofire
import RxSwift

final class BaseInterceptor: RequestInterceptor {
    
    private let tokenRepository = TokenRepository()
    private let disposeBag = DisposeBag()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let accessToken = UserDefaults.token
        let refreshToken = UserDefaults.refreshToken
        
        if accessToken.isEmpty || refreshToken.isEmpty {
            completion(.success(urlRequest))
        } else {
            var request = urlRequest
            request.headers.add(name: "Authorization", value: accessToken)
            request.headers.add(name: "Sesackey", value: APIManagement.key)
            completion(.success(urlRequest))
        }
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, 
                response.statusCode == 419 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        tokenRepository.refresh(
            authorization: UserDefaults.token,
            refresh: UserDefaults.refreshToken
        )
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let data):
                UserDefaults.token = data.token
                completion(.retry)
            case .failure(let error):
                switch error {
                case .needLoginAgain:
                    UserDefaults.isLogin = false
                    UserDefaults.token = ""
                    UserDefaults.refreshToken = ""
                    let window = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let vc = LoginVC(viewModel: LoginViewModel(userRepository: AuthRepository()))
                    window?.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                default:
                    completion(.doNotRetryWithError(error))
                }
            }
        }
        .disposed(by: disposeBag)
        
    }
}
