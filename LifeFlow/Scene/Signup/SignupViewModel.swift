//
//  SignupViewModel.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/24.
//

import Foundation

import RxSwift
import RxCocoa

final class SignupViewModel: BaseViewModel {
    
    struct Input {
        let emailText: ControlProperty<String>
        let pwText: ControlProperty<String>
        let pwCheckText: ControlProperty<String>
        let nicknameText: ControlProperty<String>
        let signUpTab: ControlEvent<Void>
    }
    
    struct Output {
        let signUpTab: ControlEvent<Void>
        let emailValidate: Observable<Bool>
        let pwValidate: Observable<Bool>
        let pwCheckValidate: Observable<Bool>
        let nicknameValidate: Observable<Bool>
        let signUpAvailable: Observable<Bool>       // 회원가입 할 수 있는 상태인지
    }
    
    func transform(input: Input) -> Output {
        let emailValidate = input.emailText.map {
            ValidateManager.shared.isValidEmail(email: $0)
        }
        let pwValidate = input.pwText.map {
            ValidateManager.shared.isValidPassword(password: $0)
        }
        let pwCheckValidate = Observable.combineLatest(pwValidate, input.pwCheckText, input.pwText) { pwValidate, checkPw, pw in
            if pwValidate {
                if checkPw.isEmpty {
                    false
                } else {
                    checkPw == pw
                }
            } else {
                false
            }
        }
        let nicknameValidate = input.nicknameText.map {
            ValidateManager.shared.isValidNickname(nickname: $0)
        }
        
        let signUpAvailable =
        Observable.combineLatest(emailValidate, pwValidate, pwCheckValidate, nicknameValidate) { email, pw, pwCheck, nickname in
            return email && pw && pwCheck && nickname
        }

        return Output(
            signUpTab: input.signUpTab,
            emailValidate: emailValidate,
            pwValidate: pwValidate,
            pwCheckValidate: pwCheckValidate,
            nicknameValidate: nicknameValidate,
            signUpAvailable: signUpAvailable
        )
    }
    
    
}
