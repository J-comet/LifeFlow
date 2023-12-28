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
    
    init(
        profileRepository: ProfileRepository,
        postRepository: PostRepository
    ) {
        self.profileRepository = profileRepository
        self.postRepository = postRepository
    }
    
    private let dispatchGroup = DispatchGroup()
    
    private var _myInfo: UserInfoEntity? = nil
    private var _posts: [PostEntity] = []
    private var _errorMsg = ""
    let myInfo: BehaviorRelay<UserInfoEntity?> = BehaviorRelay(value: nil)
    let posts: BehaviorRelay<[PostEntity]> = BehaviorRelay(value: [])
    
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
    
    
}
