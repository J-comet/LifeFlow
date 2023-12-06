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
    
    private var next = ""
    private var tmpPosts: [PostEntity] = []
    
    var posts: BehaviorRelay<[PostEntity]> = BehaviorRelay(value: [])
    
    func getPosts() {
        isLoading.accept(true)
        postRepository.getPosts(next: next)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    print(data)
                    owner.next = data.nextCursor
                    owner.tmpPosts.append(contentsOf: data.data)
                    owner.posts.accept(owner.tmpPosts)
                case .failure(let error):
                    print(error)
                    owner.errorMessage.accept(error.message)
                }
                owner.isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
}
