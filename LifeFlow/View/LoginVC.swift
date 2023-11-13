//
//  LoginVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/13.
//

import UIKit

import RxSwift
import Alamofire
import RxAlamofire

final class LoginVC: UIViewController {
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan


//        callRxPost()
    }
    
    func callRxPost() {
        RxAlamofire
            .requestJSON(
                Router.join(
                    request:
                        RequestJoinModel(
                            email: "aba@aaa.com",
                            password: "1234", nick: "soso"
                        )
                )
            )
            .subscribe { (response, data) in
                print(response.statusCode)
                print(data)
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: bag)
    }
    
}
