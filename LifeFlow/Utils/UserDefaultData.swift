//
//  UserDefaultData.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/25.
//

import Foundation

@propertyWrapper
struct UserDefaultData<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

enum UserDefaultsKey: String {
    case isLogin
    case token
    case refreshToken
}

extension UserDefaults {
    @UserDefaultData(key: UserDefaultsKey.isLogin.rawValue, defaultValue: false)
    static var isLogin: Bool
    
    @UserDefaultData(key: UserDefaultsKey.token.rawValue, defaultValue: "")
    static var token: String
    
    @UserDefaultData(key: UserDefaultsKey.refreshToken.rawValue, defaultValue: "")
    static var refreshToken: String
}
