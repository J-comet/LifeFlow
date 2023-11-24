//
//  SignupVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/24.
//

import UIKit

final class SignupVC: BaseViewController<SignupView, SignupViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
    }

}

extension SignupVC {
    
    func bindViewModel() {
        
    }
    
    func configureVC() {
        navigationController?.navigationBar.tintColor = .lightGray
    }
}
