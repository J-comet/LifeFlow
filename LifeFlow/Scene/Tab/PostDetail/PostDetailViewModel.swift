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
    let collectionViewDataSource: BehaviorRelay<[PostDetailSectionModel]> = BehaviorRelay(value: [])
    
    init(postDetail: BehaviorRelay<PostEntity>) {
        self.postDetail = postDetail
        self.collectionViewDataSource.accept(
            [
                PostDetailSectionModel(header: postDetail.value, items: postDetail.value.comments)
            ]
        )
    }
    
    
    
}
