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
    
    private var postRepository: PostRepository
    
    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    private var next = ""
    private var tmpPosts: [PostEntity] = []
    
    var isNext = false
    var posts: BehaviorRelay<[PostEntity]> = BehaviorRelay(value: [])
    
    func resetData() {
        tmpPosts = []
        posts.accept(tmpPosts)
    }
    
    func getPosts() {
        isLoading.accept(true)
        postRepository.getPosts(next: next)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    print(data.nextCursor)
                    
                    if data.nextCursor == "0" {
                        owner.isNext = false
                    } else {
                        owner.isNext = true
                    }
                    
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
    
    func like(id: String) {
        postRepository.like(id: id)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let like):
                    print(like.likeStatus)
                    let updatePosts = owner.posts.value.map {
                        var updateItem = $0
                        if updateItem.id == id {
                            if like.likeStatus {
                                updateItem.likes.append(UserDefaults.userId)
                                return updateItem
                            } else {
                                updateItem.likes = updateItem.likes.filter { $0 != UserDefaults.userId }
                                return updateItem
                            }
                        } else {
                            return $0
                        }
                    }
                    
                    owner.posts.accept(updatePosts)
                    
                case .failure(let error):
                    owner.errorMessage.accept(error.message)
                }
            }
            .disposed(by: disposeBag)
    }
}
