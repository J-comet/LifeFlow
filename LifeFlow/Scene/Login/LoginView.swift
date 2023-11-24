//
//  LoginView.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/17.
//

import UIKit

import SnapKit
import Then

final class LoginView: BaseView {
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    let appTitleLabel = BasicLabel().then {
        $0.text = "LIFE FLOW"
        $0.font(weight: .bold, size: 40)
        $0.textColor = .main
        $0.textAlignment = .center
        $0.snp.makeConstraints { make in
            make.height.equalTo(160)
        }
    }
    
    let emailTextFiled = BasicTextField(placeholderText: "이메일을 입력해주세요").then {
        $0.textContentType = .emailAddress
    }
    
    let pwTextFiled = BasicTextField(placeholderText: "비밀번호를 입력해주세요").then {
        $0.isSecureTextEntry = true
    }
    
    let signupButton = UIButton().then {
        var attString = AttributedString("회원가입")
        attString.font = UIFont(name: SpoqaHanSansNeoFonts.light.rawValue, size: 14)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attString
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .gray
        $0.configuration = config
    }
    
    let loginButton = BasicButton(title: "로그인").then {
        $0.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    override func configureHierarchy() {
        addSubview(contentStackView)
        addSubview(signupButton)
        contentStackView.addArrangedSubview(appTitleLabel)
        contentStackView.addArrangedSubview(emailTextFiled)
        contentStackView.addArrangedSubview(pwTextFiled)
        contentStackView.addArrangedSubview(loginButton)
    }
    
    override func configureLayout() {
        contentStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(safeAreaLayoutGuide).multipliedBy(0.6)
            make.width.equalTo(self.snp.width).multipliedBy(0.8)
        }
        
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(contentStackView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentStackView)
            make.height.equalTo(50)
        }
    }
}
