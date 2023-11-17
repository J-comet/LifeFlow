//
//  BaseViewModel.swift
//  SeSACRxSummery
//
//  Created by 장혜성 on 2023/11/08.
//

import Foundation

import RxSwift
import RxCocoa

/**
 ConcreateType Protocol = ???
 */
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class TestViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
