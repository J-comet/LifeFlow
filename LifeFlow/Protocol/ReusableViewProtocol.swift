//
//  ReusableViewProtocol.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/28.
//

import UIKit

public protocol ReusableViewProtocol {
    static var identifier: String { get }
}

extension UIViewController: ReusableViewProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: ReusableViewProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableViewProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}
