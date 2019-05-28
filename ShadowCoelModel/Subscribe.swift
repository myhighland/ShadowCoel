//
//  Subscribe.swift
//  ShadowCoelModel
//
//  Created by Coel on 2019/5/20.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import RealmSwift

public enum SubscribeError: Error {
    case invalidUrl
    case emptyName
    case nameAlreadyExists
}

extension SubscribeError: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .invalidUrl:
            return "Invalid Url"
        case .emptyName:
            return "Empty name"
        case .nameAlreadyExists:
            return "Name already exists"
        }
    }
    
}

open class Subscribe: BaseModel {
    @objc open dynamic var name: String = ""
    @objc open dynamic var url: String = ""
}
