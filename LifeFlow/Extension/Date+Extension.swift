//
//  Date+Extension.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/01.
//

import Foundation

extension Date {
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd kk:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        return dateFormatter.string(from: self)
    }
}
