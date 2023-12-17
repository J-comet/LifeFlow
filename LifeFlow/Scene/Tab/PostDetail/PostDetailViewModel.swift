//
//  PostDetailViewModel.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/07.
//

import Foundation

import RxSwift
import RxCocoa

final class PostDetailViewModel: BaseViewModel {
    let postDetail: BehaviorRelay<PostEntity>
    let postRepository: PostRepository
    let commentRepository: CommentRepository
    
    let collectionViewDataSource: BehaviorRelay<[PostDetailSectionModel]> = BehaviorRelay(value: [])
    
    let deletedPostID = PublishRelay<String>()
    
    let commentText = BehaviorRelay(value: "")
    
    let createCommentSuccess = PublishRelay<PostEntity>()
    
    init(
        postDetail: BehaviorRelay<PostEntity>,
        postRepository: PostRepository,
        commentRepository: CommentRepository
    ) {
        self.postDetail = postDetail
        self.postRepository = postRepository
        self.commentRepository = commentRepository
    }
    
    func delete() {
        isLoading.accept(true)
        postRepository.deletePost(id: postDetail.value.id)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let entity):
                    dump(entity)
                    owner.deletedPostID.accept(entity.id)
                case .failure(let error):
                    owner.errorMessage.accept(error.message)
                }
                owner.isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
   
    func createComment() {
        
        if commentText.value.isEmpty {
            errorMessage.accept("댓글을 입력해주세요")
            return
        }
        
        isLoading.accept(true)
        commentRepository.create(id: postDetail.value.id, content: commentText.value)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let comment):
                    var postDetail = owner.postDetail.value
                    postDetail.comments.insert(comment, at: 0)
                    owner.createCommentSuccess.accept(postDetail)
                case .failure(let error):
                    print(error.message)
                    owner.errorMessage.accept(error.message)
                }
                owner.isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
}
