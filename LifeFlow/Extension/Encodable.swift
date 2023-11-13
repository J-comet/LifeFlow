//
//  Encodable.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/13.
//

import Foundation

extension Encodable {
    
    var toEncodable : [String: String] {
        guard let object = try? JSONEncoder().encode(self) else { return ["": ""] }
        guard let parameters = try? JSONSerialization.jsonObject(with: object, options: []) as? [String : String] else { return ["": ""] }
        return parameters
    }
}
