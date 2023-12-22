//
//  TabBarVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/28.
//

import UIKit

import SnapKit

final class TabBarVC: UITabBarController {
    
    let inputButton = UIButton(type: .custom)
    
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
        view.addSubview(inputButton)
        inputButton.backgroundColor = .white
        inputButton.layer.cornerRadius = CGFloat((UIScreen.main.bounds.width * 0.16) / 2)
        inputButton.snp.makeConstraints { make in
            make.size.equalTo(self.view.snp.width).multipliedBy(0.16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(8)
            make.centerX.equalToSuperview()
        }

        inputButton.setBackgroundImage(UIImage(systemName: "plus.circle.fill")?.withTintColor(.main, renderingMode: .alwaysOriginal), for: .normal)
        inputButton.setBackgroundImage(UIImage(systemName: "plus.circle.fill")?.withTintColor(.main, renderingMode: .alwaysOriginal), for: .highlighted)
        inputButton.addTarget(self, action: #selector(addBtnTabbed), for:.touchUpInside)
    }
    
    @objc
    func addBtnTabbed() {
        let vc = PostInputVC(
            viewModel: PostInputViewModel(
                editData: nil,
                postRepository: PostRepository()
            )
        )
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
                return HomeVC(viewModel: HomeViewModel(postRepository: PostRepository()))
            case .emty:
                return EmptyVC()
            case .profile:
                return ProfileVC(viewModel: ProfileViewModel(profileRepository: ProfileRepository()))
            }
        }
        
        var icon: UIImage {
            switch self {
            case .home:
                return .tabHome
            case .emty:
                return UIImage(systemName: "star")!
            case .profile:
                return UIImage(systemName: "person.circle")!
            }
        }
    }
}

class EmptyVC: UIViewController {
    
}
