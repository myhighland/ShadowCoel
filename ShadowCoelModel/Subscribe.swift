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
    @objc open dynamic var update: Bool = true
    @objc open dynamic var url: String = ""
    
    public static let subscribePrefix = "subscribe://"
}

// Public
extension Subscribe {
    open func Uri() -> String {
        if let name = Optional(name),
        let url = Optional(url) {
            let name_base64 = name.data(using: .utf8)?.base64EncodedString()
            let name_base64_1 = name_base64!.replacingOccurrences(of: "=", with: "")
            let name_base64_2 = name_base64_1.replacingOccurrences(of: "/", with: "_")
            let url_base64 = url.data(using: .ascii)?.base64EncodedString()
            let url_base64_1 = url_base64!.replacingOccurrences(of: "=", with: "")
            let url_base64_2 = url_base64_1.replacingOccurrences(of: "/", with: "_")
            let subscribe_uri = "\(name_base64_2):\(url_base64_2)"
            return "subscribe://" + subscribe_uri
        }
        return ""
    }
    
    public class func uriIsSubscribe(_ uri: String) -> Bool {
        return uri.lowercased().hasPrefix(Subscribe.subscribePrefix)
    }
    
}
