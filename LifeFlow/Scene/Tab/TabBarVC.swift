//
//  TabBarVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/28.
//

import UIKit

import SnapKit

final class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 0
        let viewControllers = [tapVC(type: .home), tapVC(type: .emty), tapVC(type: .profile)]
        setViewControllers(viewControllers, animated: true)
        
        tabBar.barTintColor = .background
        tabBar.backgroundColor = .background
        tabBar.tintColor = .background
        tabBar.isTranslucent = false
        //        tabBar.unselectedItemTintColor = .black
        
        let button = UIButton(type: .custom)
        view.addSubview(button)
        button.backgroundColor = .white
        button.layer.cornerRadius = CGFloat((UIScreen.main.bounds.width * 0.16) / 2)
        button.snp.makeConstraints { make in
            make.size.equalTo(self.view.snp.width).multipliedBy(0.16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(8)
            make.centerX.equalToSuperview()
        }
        
        button.setBackgroundImage(UIImage(systemName: "plus.circle.fill")?.withTintColor(.main, renderingMode: .alwaysOriginal), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "plus.circle.fill")?.withTintColor(.main, renderingMode: .alwaysOriginal), for: .highlighted)
        button.addTarget(self, action: #selector(addBtnTabbed), for:.touchUpInside)
        
    }
    
    @objc
    func addBtnTabbed() {
        let vc = PostInputVC(viewModel: PostInputViewModel(postRepository: PostRespository()))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func tapVC(type: TabType) -> UINavigationController {
        let nav = UINavigationController()
        nav.addChild(type.vc)

        if type == .emty {
            nav.tabBarItem.image = type.icon.withTintColor(.clear, renderingMode: .alwaysOriginal)
            nav.tabBarItem.selectedImage = type.icon.withTintColor(.clear, renderingMode: .alwaysOriginal)
        } else {
            nav.tabBarItem.image = type.icon.withTintColor(.systemGray4, renderingMode: .alwaysOriginal)
            nav.tabBarItem.selectedImage = type.icon.withTintColor(.main, renderingMode: .alwaysOriginal)
        }
        
        //        nav.tabBarItem.title = type.title
        return nav
    }
}

extension TabBarVC {
    
    enum TabType {
        case home
        case emty
        case profile
        
        var vc: UIViewController {
            switch self {
            case .home:
                return HomeVC(viewModel: HomeViewModel())
            case .emty:
                return EmptyVC()
            case .profile:
                return ProfileVC(viewModel: ProfileViewModel())
            }
        }
        
        var icon: UIImage {
            switch self {
            case .home:
                return .tabHome
            case .emty:
                return UIImage(systemName: "xmark")!
            case .profile:
                return UIImage(systemName: "person.circle")!
            }
        }
    }
}

class EmptyVC: UIViewController {
    
}
