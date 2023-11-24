//
//  LoginVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/13.
//

import UIKit

import Alamofire
import RxSwift
import RxCocoa

final class LoginVC: BaseViewController<LoginView, LoginViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
        
//        repository.login(email: "z@z.com", password: "zzzzzzzz2")
//            .subscribe { response in
//                switch response {
//                case .success(let result):
//                    switch result {
//                    case .success(let data):
//                        print("111111")
//                        print(data)
//                    case .failure(let loginError):
//                        print("2222222")
//                        self.showAlert(title: "", msg: loginError.message, ok: "확인")
//                        print(loginError.localizedDescription)
//                    }
//                case .failure(let error):
//                    print("33333333")
//                    print(error.localizedDescription)
//                }
//            }
//            .disposed(by: viewModel.disposeBag)
    }
    
    // TODO: 회원가입 통신까지 끝낸 후 로그인 기능 개발
    func bindViewModel() {

        let isEmailVaild = mainView.emailTextFiled
            .rx
            .text
            .orEmpty
            .map { $0.count >= 8 } // 이메일 정규식 검사하기
            .distinctUntilChanged()
        
        let isPasswordValid = mainView.pwTextFiled.rx.text.orEmpty
            .map { $0.count >= 8 }
            .distinctUntilChanged()
            
        let isLoginButtonEnabled = Observable.combineLatest(isEmailVaild, isPasswordValid) { email, password in
            email && password
        }
            
        let isButtonEnabled = Observable.combineLatest(isPasswordValid, isEmailVaild) { $0 && $1 }

        isButtonEnabled
            .bind(to: mainView.loginButton.rx.isEnabled)
            .disposed(by: viewModel.disposeBag)
        
        mainView.signupButton
            .rx
            .tap
            .bind(with: self) { owner, _ in
                let vc = SignupVC(viewModel: SignupViewModel(userRepository: UserRepository()))
                owner.navigationItem.backButtonDisplayMode = .minimal
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    func configureVC() {
        
    }
    
}
