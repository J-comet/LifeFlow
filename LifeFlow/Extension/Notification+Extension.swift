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
    static let editPost = Notification.Name("editPost")
}

enum NotificationKey {
    case reloadDetailPost       // Post 상세페이지 reload
    case editPost              // HomeVC 로 왔을 때 수정된 Post 업데이트
}
