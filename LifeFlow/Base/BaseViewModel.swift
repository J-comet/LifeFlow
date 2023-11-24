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
    
    var isLoading = PublishRelay<Bool>()
    
    var disposeBag = DisposeBag()

}
