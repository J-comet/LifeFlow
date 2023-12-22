//
//  ProfileVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/28.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

final class ProfileVC: BaseViewController<ProfileView, ProfileViewModel> {
    
    private lazy var actions = [
        UIAction(title: "프로필수정", identifier: UIAction.Identifier("edit_profile"), handler: self.settingHandler),
        UIAction(title: "로그아웃", identifier: UIAction.Identifier("logout"), handler: self.settingHandler),
        UIAction(title: "회원탈퇴", identifier: UIAction.Identifier("withdraw"), handler: self.settingHandler)
     ]

    private lazy var menu = UIMenu(title: "",  children: self.actions)
    
    private let settingHandler: (_ action: UIAction) -> Void = { action in
      switch action.identifier.rawValue {
      case "edit_profile":
        print("프로필수정 화면으로 이동")
      case "logout":
        print("로그아웃 하기")
      case "withdraw":
        print("회원탈퇴 하기")
      default:
        break
      }
    }
    
    private lazy var settingButton = UIBarButtonItem(
        title: "",
        image: UIImage(systemName: "gearshape.fill")?.defaultIconStyle,
        menu: menu
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
        
        viewModel.fetchData()
    }
}

extension ProfileVC {
    
    func bindViewModel() {
        
        viewModel.myInfo
            .bind(with: self) { owner, entity in
                guard let entity else {
                    return
                }
                owner.mainView.emailLabel.text = entity.email
                owner.mainView.nicknameLabel.text = entity.nick
                owner.mainView.profileImageView.loadImage(from: entity.profile, placeHolderImage: UIImage().defaultUser)
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.posts
            .bind(to: mainView.postCollectionView.rx.items(cellIdentifier: GridPostCell.identifier, cellType: GridPostCell.self)) { (row, element, cell) in
                cell.configCell(row: element)
            }
            .disposed(by: viewModel.disposeBag)
        
        Observable.zip(mainView.postCollectionView.rx.itemSelected, mainView.postCollectionView.rx.modelSelected(PostEntity.self))
            .subscribe(with: self) { owner, selectedItem in
                let vc = PostDetailVC(
                    viewModel: PostDetailViewModel(
                        postDetail: BehaviorRelay(value: selectedItem.1),
                        postRepository: PostRepository(),
                        commentRepository: CommentRepository()
                    )
                )
                vc.modalPresentationStyle = .fullScreen
                owner.present(vc, animated: false)
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.isLoading
            .bind { isLoading in
                if isLoading {
                    LoadingIndicator.show()
                } else {
                    LoadingIndicator.hide()
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        
        viewModel.errorMessage
            .bind(with: self) { owner, message in
                print(message)
                owner.showToast(msg: message)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    func configureVC() {
        navigationItem.rightBarButtonItem = settingButton
    }
}
