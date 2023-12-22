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
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }
    
    let myInfo: BehaviorRelay<UserInfoEntity?> = BehaviorRelay(value: nil)
    let postIds: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    func fetchMyInfo() {
        isLoading.accept(true)
        profileRepository.me()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let userInfo):
                    print(userInfo)
                    owner.myInfo.accept(userInfo)
                    owner.postIds.accept(userInfo.posts)
                case .failure(let error):
                    owner.errorMessage.accept(error.message)
                }
                owner.isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    
    
}
