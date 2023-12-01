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
    
    private var userRepository: AuthRepository
    
    init(userRepository: AuthRepository) {
        self.userRepository = userRepository
    }
    
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
        let signUpData: SharedSequence<DriverSharingStrategy, (isAvailable: Bool, email: String, password: String, nickname: String)>
        let joinSuccess: PublishRelay<JoinEntity>
        let errorMessage: PublishRelay<String>
    }
    
    let joinSuccess = PublishRelay<JoinEntity>()
    
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
        
        let signUpData = Driver.combineLatest(
            signUpAvailable.asDriver(onErrorJustReturn: false),
            input.emailText.asDriver(),
            input.pwText.asDriver(),
            input.nicknameText.asDriver()
        ) { (isAvailable: $0, email: $1, password: $2, nickname: $3) }
        
        return Output(
            signUpTab: input.signUpTab,
            emailValidate: emailValidate,
            pwValidate: pwValidate,
            pwCheckValidate: pwCheckValidate,
            nicknameValidate: nicknameValidate,
            signUpData: signUpData,
            joinSuccess: joinSuccess,
            errorMessage: errorMessage
        )
    }
    
    func checkExistEmail(email: String, password: String, nickname: String) {
        isLoading.accept(true)
        userRepository.chkEmail(email: email)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    owner.join(email: email, password: password, nickname: nickname)
                case .failure(let error):
                    owner.errorMessage.accept(error.message)
                    owner.isLoading.accept(false)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func join(email: String, password: String, nickname: String) {
        userRepository.join(email: email, password: password, nick: nickname)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    owner.joinSuccess.accept(data)
                case .failure(let error):
                    owner.errorMessage.accept(error.message)
                }
                owner.isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
}
