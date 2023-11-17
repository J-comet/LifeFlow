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
    
    private let containerView = UIView()
    
    let emailTextFiled = BasicTextField(placeholderText: "이메일을 입력해주세요").then {
        $0.textContentType = .emailAddress
    }
    
    let pwTextFiled = BasicTextField(placeholderText: "비밀번호를 입력해주세요").then {
        $0.textContentType = .password
    }
    
    let loginButton = BasicButton(title: "로그인")
    
    override func configureHierarchy() {
        addSubview(containerView)
        containerView.addSubview(emailTextFiled)
        containerView.addSubview(pwTextFiled)
        containerView.addSubview(loginButton)
    }
    
    override func configureLayout() {
        containerView.backgroundColor = .cyan
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(self.snp.width).multipliedBy(0.8)
        }
        
        emailTextFiled.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview()
        }
        
        pwTextFiled.snp.makeConstraints { make in
            make.top.equalTo(emailTextFiled.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(pwTextFiled.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview()
        }
    }
}
