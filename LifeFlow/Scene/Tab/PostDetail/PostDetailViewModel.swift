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
//    let postDetail: PostEntity
    
    let postDetail: BehaviorRelay<PostEntity>
    
    init(postDetail: BehaviorRelay<PostEntity>) {
        self.postDetail = postDetail
    }
}
