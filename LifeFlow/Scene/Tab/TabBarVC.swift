//
//  TabBarVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/28.
//

import UIKit

final class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 0
        let viewControllers = [tapVC(type: .home), tapVC(type: .profile)]
        setViewControllers(viewControllers, animated: true)
        
        tabBar.barTintColor = .background
        tabBar.backgroundColor = .background
        tabBar.tintColor = .background
        tabBar.isTranslucent = false
        //        tabBar.unselectedItemTintColor = .black
    }
    
    private func tapVC(type: TabType) -> UINavigationController {
        let nav = UINavigationController()
        nav.addChild(type.vc)
        nav.tabBarItem.image = type.icon.withTintColor(.systemGray4, renderingMode: .alwaysOriginal)
        nav.tabBarItem.selectedImage = type.icon.withTintColor(.main, renderingMode: .alwaysOriginal)
        //        nav.tabBarItem.title = type.title
        return nav
    }
}

extension TabBarVC {
    
    enum TabType {
        case home
        case profile
        
        var vc: UIViewController {
            switch self {
            case .home:
                return HomeVC(viewModel: HomeViewModel())
            case .profile:
                return ProfileVC(viewModel: ProfileViewModel())
            }
        }
        
        var icon: UIImage {
            switch self {
            case .home:
                return .tabHome
            case .profile:
                return UIImage(systemName: "person.fill")!
            }
        }
    }
}
