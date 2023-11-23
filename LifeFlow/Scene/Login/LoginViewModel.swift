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
    
    func login(email: String, password: String) {
        userRepository.login(email: email, password: password)
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
    
}
