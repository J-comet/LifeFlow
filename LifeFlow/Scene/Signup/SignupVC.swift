//
//  SignupVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/24.
//

import UIKit

import RxSwift
import RxCocoa

final class SignupVC: BaseViewController<SignupView, SignupViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
    }

}

extension SignupVC {
    
    func bindViewModel() {
        
        let input = SignupViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty,
            pwText: mainView.pwTextField.rx.text.orEmpty,
            pwCheckText: mainView.pwCheckTextField.rx.text.orEmpty,
            nicknameText: mainView.nicknameTextField.rx.text.orEmpty,
            signUpTab: mainView.signUpButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.emailValidate
            .bind(to: mainView.errorEmailLabel.rx.isHidden)
            .disposed(by: viewModel.disposeBag)
        
        output.pwValidate
            .bind(to: mainView.errorPwLabel.rx.isHidden)
            .disposed(by: viewModel.disposeBag)
        
        output.pwCheckValidate
            .bind(to: mainView.errorPwCheckLabel.rx.isHidden)
            .disposed(by: viewModel.disposeBag)
        
        output.nicknameValidate
            .bind(to: mainView.errorNicknameLabel.rx.isHidden)
            .disposed(by: viewModel.disposeBag)
        
        output.signUpTab
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(output.signUpData)
            .bind(with: self) { owner, signUpData in
                if signUpData.isAvailable {
                    owner.viewModel.checkExistEmail(
                        email: signUpData.email,
                        password: signUpData.password,
                        nickname: signUpData.nickname
                    )
                } else {
                    owner.showAlert(title: "", msg: "모든 정보를 정확히 입력해주세요", ok: "확인")
                }
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
        
        output.errorMessage
            .bind(with: self) { owner, message in
                owner.showToast(msg: message)
            }
            .disposed(by: viewModel.disposeBag)
        
        output.joinSuccess
            .bind(with: self) { owner, value in
                owner.showAlert(title: "", msg: "가입 완료", ok: "확인") { _ in
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    func configureVC() {
        navigationController?.navigationBar.tintColor = .lightGray
    }
}
