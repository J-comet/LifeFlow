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
    
    var selectedImages: [PhpickerImage] = [PhpickerImage(image: nil)]
    var previewImages: BehaviorRelay<[PhpickerImage]> = BehaviorRelay(value: [PhpickerImage(image: nil)])
    
}
