//
//  BaseViewModel.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/17.
//

import Foundation

import RxSwift
import RxCocoa

//typealias BaseViewModel = ViewModel & ViewModelType

class BaseViewModel {
    
    let isLoading = BehaviorRelay(value: false)
    let errorMessage = PublishRelay<String>()
    
    var disposeBag = DisposeBag()

}
