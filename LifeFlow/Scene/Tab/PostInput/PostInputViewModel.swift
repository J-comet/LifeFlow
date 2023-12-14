//
//  PostInputViewModel.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/29.
//

import Foundation

import RxSwift
import RxCocoa

final class PostInputViewModel: BaseViewModel {
    
    var editData = BehaviorRelay<PostEntity?>(value: nil)
    private var postRepository: PostRespository
    
    init(
        editData: PostEntity?,
        postRepository: PostRespository
    ) {
        self.editData.accept(editData)
        self.postRepository = postRepository
    }
    
    let title = BehaviorRelay(value: "")
    let content = BehaviorRelay(value: "")
    
    var selectedImages: [PhpickerImage] = [PhpickerImage(image: nil)]
    let previewImages: BehaviorRelay<[PhpickerImage]> = BehaviorRelay(value: [PhpickerImage(image: nil)])
    var passImageDatas: [Data] = []
    
    let createSuccess = PublishRelay<PostEntity>()
    
    func create() {
        
        if previewImages.value.count - 1 == 0 {
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

        previewImages.value.forEach { pickerImage in
            if let image = pickerImage.image {
                passImageDatas.append(image.jpegData(compressionQuality: 1)!)
            }
        }
        
        postRepository.create(
            productId: Constant.ProductID.post,
            params: PostCreateRequest(product_id: Constant.ProductID.post, title: title.value, content: content.value),
            images: passImageDatas
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
