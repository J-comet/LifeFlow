//
//  HomeViewModel.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/28.
//

import Foundation

import RxSwift
import RxCocoa

final class HomeViewModel: BaseViewModel {
    
    private var postRepository: PostRespository
    
    init(postRepository: PostRespository) {
        self.postRepository = postRepository
    }
    
//    var posts: BehaviorRelay<[PostEntity]> = BehaviorRelay(value: [])
    
    func getPosts(next: String) {
        print("1234")
        postRepository.get(next: next)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    print(data)
//                    owner.posts.accept(<#T##event: [PostEntity]##[PostEntity]#>)
                case .failure(let error):
                    print(error)
                    owner.errorMessage.accept(error.message)
                }
            }
            .disposed(by: disposeBag)
    }
}
