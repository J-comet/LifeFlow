//
//  UserRepository.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/14.
//

import Foundation

import RxSwift

protocol UserRepositoryProtocol {
    func login() -> Observable<ResponseLoginModel>
}

//final class UserRepository: UserRepositoryProtocol {
//    static let shared = UserRepository()
//    private init() {}
//    
//    private var disposeBag = DisposeBag()
//    
//    func login() -> Observable<ResponseLoginModel> {
//        
//    }
//    
//}
