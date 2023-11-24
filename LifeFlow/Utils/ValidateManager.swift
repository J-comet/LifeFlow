//
//  ValidateManager.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/24.
//

import Foundation

final class ValidateManager {
    static let shared = ValidateManager()
    private init() { }
    
    func isValidEmail(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,16}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }
    
    func isValidNickname(nickname: String) -> Bool {
        let regex = "^(?=.*[A-Za-z0-9]).{2,8}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: nickname)
    }
}
