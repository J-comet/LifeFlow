//
//  Notification+Extension.swift
//  LifeFlow
//
//  Created by 장혜성 on 12/13/23.
//

import Foundation

extension Notification.Name {
    static let reloadPost = Notification.Name("reloadPost")
    static let reloadPostDetail = Notification.Name("reloadPostDetail")
}

enum NotificationKey {
    case reloadDetailPost
}
