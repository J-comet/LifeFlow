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
    let postRepository: PostRespository
    
    let collectionViewDataSource: BehaviorRelay<[PostDetailSectionModel]> = BehaviorRelay(value: [])
    
    let deletedPostID = PublishRelay<String>()
    
    init(
        postDetail: BehaviorRelay<PostEntity>,
        postRepository: PostRespository
    ) {
        self.postDetail = postDetail
        self.postRepository = postRepository
    }
    
    func delete(){
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
    
}
