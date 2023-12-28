//
//  ProfileViewModel.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/28.
//

import Foundation

import RxSwift
import RxCocoa

final class ProfileViewModel: BaseViewModel {
    private var profileRepository: ProfileRepository
    private var postRepository: PostRepository
    private var authRepository: AuthRepository
    
    init(
        profileRepository: ProfileRepository,
        postRepository: PostRepository,
        authRepository: AuthRepository
    ) {
        self.profileRepository = profileRepository
        self.postRepository = postRepository
        self.authRepository = authRepository
    }
    
    private let dispatchGroup = DispatchGroup()
    
    private var _myInfo: UserInfoEntity? = nil
    private var _posts: [PostEntity] = []
    private var _errorMsg = ""
    let myInfo: BehaviorRelay<UserInfoEntity?> = BehaviorRelay(value: nil)
    let posts: BehaviorRelay<[PostEntity]> = BehaviorRelay(value: [])
    let withdrawStatus = BehaviorRelay(value: false)
    
    func fetchData() {
        isLoading.accept(true)
        fetchMyInfo()
        fetchMyPosts()
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.myInfo.accept(_myInfo)
            self.posts.accept(_posts)
            self.isLoading.accept(false)
        }
    }
    
    func fetchMyInfo() {
        dispatchGroup.enter()
        profileRepository.me()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let userInfo):
                    print(userInfo)
                    owner._myInfo = userInfo
                case .failure(let error):
                    owner._errorMsg = error.message
                }
                owner.dispatchGroup.leave()
            }
            .disposed(by: disposeBag)
    }
    
    func fetchMyPosts() {
        dispatchGroup.enter()
        postRepository.getPostsByUser(id: UserDefaults.userId)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let posts):
                    owner._posts = posts.data
                case .failure(let error):
                    owner._errorMsg = error.message
                }
                owner.dispatchGroup.leave()
            }
            .disposed(by: disposeBag)
    }
    
    func withdraw() {
        isLoading.accept(true)
        authRepository.withdraw()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    owner.withdrawStatus.accept(true)
                case .failure(let error):
                    owner._errorMsg = error.message
                }
                owner.isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
}
