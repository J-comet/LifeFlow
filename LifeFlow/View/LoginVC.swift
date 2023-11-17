//
//  LoginVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/13.
//

import UIKit

import RxSwift
import Alamofire

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
        
        loginTest()
    }
    
    func loginTest() {
        UserRepository.shared.login(email: "hs@sesac.com", password: "1234")
            .debug()
            .subscribe(with: self) { owner, result in
                switch result {
                case.success(let data):
                    print(data.refreshToken)
                    print(data.token)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func tokenTest() {
        TokenRepository.shared.refresh(authorization: "", refresh: "")
//            .catch { error -> PrimitiveSequence<SingleTrait, Result<TokenEntity, Error>> in
//                let error = error as? TokenError
//                return .error(error!)
//            }
            .subscribe(with: self) { owner, result in
                switch result {
                case.success(let data):
                    print(data.token)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }

}
