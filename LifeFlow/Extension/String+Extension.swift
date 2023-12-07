//
//  String+Extension.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/07.
//

import Foundation

extension String {
    
    func formattedDate() -> String {
        let formatter = Foundation.DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"        
        let date  = formatter.date(from: self)
        formatter.dateFormat = "yyyy.MM.dd"
        guard let date else { return "" }
        return formatter.string(from: date)
    }
}
