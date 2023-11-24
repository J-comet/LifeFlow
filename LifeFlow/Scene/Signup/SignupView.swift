//
//  SignupView.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/24.
//

import UIKit

import SnapKit
import Then

final class SignupView: BaseView {
    
    let topTitleLabel = BasicLabel().then {
        $0.font(weight: .bold, size: 30)
        $0.textColor = .main
        $0.text = "회원가입"
    }
    
    let emailStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
    }
    
    let emailTextField = UnderLineTextField(placeholderText: "이메일을 입력해주세요")
    
    let errorEmailLabel = BasicLabel().then {
        $0.font(weight: .light, size: 12)
        $0.textColor = .error
        $0.text = "정확한 이메일을 입력해주세요"
    }
    
    let pwStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
    }

    let pwTextField = UnderLineTextField(placeholderText: "비밀번호를 입력해주세요")
    
    let errorPwLabel = BasicLabel().then {
        $0.font(weight: .light, size: 12)
        $0.textColor = .error
        $0.text = "영어, 숫자를 포함해 8~12자를 입력해주세요"
    }
    
    let pwCheckStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
    }
    
    let pwCheckTextField = UnderLineTextField(placeholderText: "비밀번호를 한번 더 입력해주세요")
    
    let errorPwCheckLabel = BasicLabel().then {
        $0.font(weight: .light, size: 12)
        $0.textColor = .error
        $0.text = "비밀번호가 일치하지 않아요"
    }
    
    let nicknameStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
    }
    
    let nicknameTextField = UnderLineTextField(placeholderText: "닉네임을 입력해주세요")
    
    let signUpButton = BasicButton(title: "회원가입")
    
    let errorNicknameLabel = BasicLabel().then {
        $0.font(weight: .light, size: 12)
        $0.textColor = .error
        $0.text = "영어, 숫자로 2~8자를 입력해주세요"
    }
    
    override func configureHierarchy() {
        addSubview(topTitleLabel)
        addSubview(emailStackView)
        addSubview(pwStackView)
        addSubview(pwCheckStackView)
        addSubview(nicknameStackView)
        addSubview(signUpButton)
        emailStackView.addArrangedSubview(emailTextField)
        emailStackView.addArrangedSubview(errorEmailLabel)
        pwStackView.addArrangedSubview(pwTextField)
        pwStackView.addArrangedSubview(errorPwLabel)
        pwCheckStackView.addArrangedSubview(pwCheckTextField)
        pwCheckStackView.addArrangedSubview(errorPwCheckLabel)
        nicknameStackView.addArrangedSubview(nicknameTextField)
        nicknameStackView.addArrangedSubview(errorNicknameLabel)
    }
    
    override func configureLayout() {
        
        topTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(24)
            make.leading.equalTo(24)
        }
        
        emailStackView.snp.makeConstraints { make in
            make.top.equalTo(topTitleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        pwStackView.snp.makeConstraints { make in
            make.top.equalTo(emailStackView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        pwTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        pwCheckStackView.snp.makeConstraints { make in
            make.top.equalTo(pwStackView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        pwCheckTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }

        nicknameStackView.snp.makeConstraints { make in
            make.top.equalTo(pwCheckStackView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(50)
        }
    }
}
