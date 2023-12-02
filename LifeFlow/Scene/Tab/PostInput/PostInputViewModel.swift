//
//  PostInputViewModel.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/29.
//

import UIKit

import RxSwift
import RxCocoa

final class PostInputViewModel: BaseViewModel {
    
    private var postRepository: PostRespository
    
    init(postRepository: PostRespository) {
        self.postRepository = postRepository
    }
    
    var selectedImages: [PhpickerImage] = [PhpickerImage(image: nil)]
    var previewImages: BehaviorRelay<[PhpickerImage]> = BehaviorRelay(value: [PhpickerImage(image: nil)])
    
    let createSuccess = PublishRelay<PostCreateEntity>()
    
    func create(title: String, content: String, images: [UIImage]) {
        isLoading.accept(true)
        postRepository.create(
            productId: "lfPostTest",
            title: title,
            content: content,
            images: images
        ).subscribe(with: self) { owner, result in
            switch result {
            case .success(let data):
                owner.createSuccess.accept(data)
            case .failure(let error):
                owner.errorMessage.accept(error.message)
            }
            owner.isLoading.accept(false)
        }
        .disposed(by: disposeBag)
    }
}
