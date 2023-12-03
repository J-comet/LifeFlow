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
    
    let title = BehaviorRelay(value: "")
    let content = BehaviorRelay(value: "")
    
    var selectedImages: [PhpickerImage] = [PhpickerImage(image: nil)]
    let previewImages: BehaviorRelay<[PhpickerImage]> = BehaviorRelay(value: [PhpickerImage(image: nil)])
    
    let createSuccess = PublishRelay<PostEntity>()
    
    func create(images: [UIImage]) {
        
        if images.isEmpty {
            errorMessage.accept("이미지를 선택해주세요")
            return
        }
        
        if title.value.isEmpty {
            errorMessage.accept("제목을 입력해주세요")
            return
        }
        
        if content.value == "내용을 입력해주세요" {
            errorMessage.accept("내용을 입력해주세요")
            return
        }
        

        isLoading.accept(true)
        postRepository.create(
            productId: Constant.ProductID.post,
            title: title.value,
            content: content.value,
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
