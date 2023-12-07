//
//  BaseViewController.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/17.
//

import UIKit

typealias BaseViewController<T: BaseView, U: BaseViewModel> = ViewController<T, U> & BaseViewContollerProtocol

protocol BaseViewContollerProtocol {
    func bindViewModel()
    func configureVC()
}

class ViewController<T: BaseView, U: BaseViewModel>: UIViewController {
    
    private lazy var tabBarVC = tabBarController as? TabBarVC
    
    var isShowDeinit: Bool { false }
    
    var mainView: T {
        return view as! T
    }
    
    var viewModel: U
    
    init(viewModel: U) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    init?(coder: NSCoder, viewModel: U) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = T.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 탭바 센터 플러스버튼 show
    func showTabBarPostInputBtn() {
        tabBarVC?.inputButton.isHidden = false
    }
    
    // 탭바 센터 플러스버튼 hide
    func hideTabBarPostInputBtn() {
        tabBarVC?.inputButton.isHidden = true
    }
    
    deinit {
        if isShowDeinit {
            print("[",String(describing: type(of: self)), "] / [deinit]")
        }
    }
}
