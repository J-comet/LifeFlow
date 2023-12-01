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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.emailTextFiled.resignFirstResponder()
        mainView.pwTextFiled.resignFirstResponder()
    }
    
    func bindViewModel() {
        
        mainView.emailTextFiled
            .rx
            .text
            .orEmpty
            .bind(with: self) { owner, email in
                owner.viewModel.email.accept(email)
            }
            .disposed(by: viewModel.disposeBag)
        
        mainView.pwTextFiled
            .rx
            .text
            .orEmpty
            .bind(with: self) { owner, password in
                owner.viewModel.password.accept(password)
            }
            .disposed(by: viewModel.disposeBag)
        
        let inputData = Driver.combineLatest(viewModel.email.asDriver(), viewModel.password.asDriver()) { (email: $0, password: $1) }
        
        mainView.loginButton
            .rx
            .tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(inputData)
            .bind(with: self) { owner, data in
                owner.mainView.emailTextFiled.resignFirstResponder()
                owner.mainView.pwTextFiled.resignFirstResponder()
                
                if data.email.isEmpty || data.password.isEmpty {
                    owner.showToast(msg: "이메일과 비밀번호를 입력해주세요")
                } else {
                    owner.viewModel.login(email: data.email, password: data.password)
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.errorMessage
            .bind(with: self) { owner, message in
                owner.showToast(msg: message)
            }
            .disposed(by: viewModel.disposeBag)
        
        mainView.emailTextFiled
            .rx
            .controlEvent(.editingDidEndOnExit)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(inputData)
            .share()
            .bind(with: self) { owner, data in
                owner.mainView.emailTextFiled.resignFirstResponder()
                owner.mainView.pwTextFiled.resignFirstResponder()
                
                if data.email.isEmpty || data.password.isEmpty {
                    owner.showToast(msg: "이메일과 비밀번호를 입력해주세요")
                } else {
                    owner.viewModel.login(email: data.email, password: data.password)
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        mainView.pwTextFiled
            .rx
            .controlEvent(.editingDidEndOnExit)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(inputData)
            .share()
            .bind(with: self) { owner, data in
                owner.mainView.emailTextFiled.resignFirstResponder()
                owner.mainView.pwTextFiled.resignFirstResponder()
                
                if data.email.isEmpty || data.password.isEmpty {
                    owner.showToast(msg: "이메일과 비밀번호를 입력해주세요")
                } else {
                    owner.viewModel.login(email: data.email, password: data.password)
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.loginSuccess
            .bind(with: self) { owner, login in
                UserDefaults.isLogin = true
                UserDefaults.token = login.token
                UserDefaults.refreshToken = login.refreshToken
                
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                sceneDelegate?.window?.rootViewController = TabBarVC()
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.isLoading
            .bind { isLoading in
                if isLoading {
                    LoadingIndicator.show()
                } else {
                    LoadingIndicator.hide()
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        mainView.signupButton
            .rx
            .tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                let vc = SignupVC(viewModel: SignupViewModel(userRepository: AuthRepository()))
                owner.navigationItem.backButtonDisplayMode = .minimal
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    func configureVC() {
        
    }
    
}
