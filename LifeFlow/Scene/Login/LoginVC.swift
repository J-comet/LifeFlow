//
//  LoginVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/13.
//

import UIKit

import Alamofire
import RxSwift



final class LoginVC: BaseViewController<LoginView, LoginViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
    }
    
    func bindViewModel() {
        
    }
    
    func configureVC() {
        
    }
    
//    func tokenTest() {
//        TokenRepository.shared.refresh(authorization: "", refresh: "")
////            .catch { error -> PrimitiveSequence<SingleTrait, Result<TokenEntity, Error>> in
////                let error = error as? TokenError
////                return .error(error!)
////            }
//            .subscribe(with: self) { owner, result in
//                switch result {
//                case.success(let data):
//                    print(data.token)
//                case .failure(let error):
//                    print(error)
//                }
//            }
//            .disposed(by: disposeBag)
//    }

}
