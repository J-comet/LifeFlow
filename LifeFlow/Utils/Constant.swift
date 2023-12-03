//
//  Constant.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/13.
//

import Foundation

enum Constant {
    static let productName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    
    enum Network {
        static let defaultHttpHeaders = [
            "Content-Type": "application/json",
            "SesacKey": APIManagement.key
        ]
    }
    
    enum ProductID {
        static let post = "lfPost" // home post
    }
}
