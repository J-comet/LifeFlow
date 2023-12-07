//
//  PassThroughView.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/07.
//

import UIKit

class PassThroughView: UIView {
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let hitView = super.hitTest(point, with: event)
    // superview가 터치 이벤트를 받을 수 있도록,
    return hitView == self ? nil : hitView
  }
}
