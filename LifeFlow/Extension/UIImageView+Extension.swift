//
//  UIImageView+Extension.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/06.
//

import UIKit
import Kingfisher


extension UIImageView {
    
    func loadImage(from url: String, placeHolderImage: UIImage? = nil) {
        let modifier = AnyModifier { request in
            var req = request
            req.addValue(UserDefaults.token, forHTTPHeaderField: "Authorization")
            req.addValue(APIManagement.key, forHTTPHeaderField: "SesacKey")
            return req
        }
        let imageURL = URL(string: APIManagement.baseURL + url)
        self.kf.setImage(
            with: imageURL,
            placeholder: placeHolderImage,
            options: [
                .requestModifier(modifier),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1))
            ]
        )
    }
    
}
