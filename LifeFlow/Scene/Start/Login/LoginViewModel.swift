//
//  LoginViewModel.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/17.
//

import Foundation

import RxSwift
import RxCocoa

final class LoginViewModel: BaseViewModel {
    
    private var userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    let loginSuccess = PublishRelay<LoginEntity>()
    
    let email = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")
    
    let inputData = 0
    
    func login(email: String, password: String) {
        isLoading.accept(true)
        userRepository.login(email: email, password: password)
            .subscribe(with: self) { owner, result in
                switch result {
                case.success(let data):
                    owner.loginSuccess.accept(data)
                case .failure(let error):
                    owner.errorMessage.accept(error.message)
                }
                owner.isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
}
