//
//  Rule.swift
//
//  Created by LEI on 4/6/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import RealmSwift
import ShadowCoelBase

private let ruleValueKey = "value";
private let ruleActionKey = "action";

// 规则类型
public enum ProxyRuleType: String {
    case URLMatch = "URL-MATCH" // 完整URL匹配
    case URL = "URL" // URL匹配
    case Domain = "DOMAIN" // 完整匹配请求域名
    case DomainMatch = "DOMAIN-MATCH" // 匹配满足关键词的域名
    case DomainSuffix = "DOMAIN-SUFFIX" // 匹配请求的域名后缀
    case GeoIP = "GEOIP" // 地理区域内的IP
    case IPCIDR = "IP-CIDR" // 域内的IP
}

extension ProxyRuleType {
    
    public static func fromInt(_ intValue: Int) -> ProxyRuleType? {
        switch intValue {
        case 1:
            return .Domain
        case 2:
            return .DomainSuffix
        case 3:
            return .DomainMatch
        case 4:
            return .URL
        case 5:
            return .URLMatch
        case 6:
            return .GeoIP
        case 7:
            return .IPCIDR
        default:
            return nil
        }
    }
    
}

extension ProxyRuleType: CustomStringConvertible {
    
    public var description: String {
        return rawValue
    }
    
}

public enum RuleAction: String {
    case Direct = "DIRECT"
    case Reject = "REJECT"
    case Proxy = "PROXY"
}

extension RuleAction {
    
    public static func fromInt(_ intValue: Int) -> RuleAction? {
        switch intValue {
        case 1:
            return .Direct // 直连
        case 2:
            return .Reject // 拒绝
        case 3:
            return .Proxy // 代理
        default:
            return nil
        }
    }
    
}

extension RuleAction: CustomStringConvertible {
    
    public var description: String {
        return rawValue
    }
    
}

public enum RuleError: Error {
    case invalidRule(String)
}

//extension RuleError: CustomStringConvertible {
//    
//    public var description: String {
//        switch self {
//        case .InvalidRule(let rule):
//            return "Invalid rule - \(rule)"
//        }
//    }
//    
//}
//
//public final class Rule: BaseModel {
//    
//    public dynamic var typeRaw = ""
//    public dynamic var content = ""
//    public dynamic var order = 0
//    public let rulesets = LinkingObjects(fromType: ProxyRuleSet.self, property: "rules")
//
//}
//
//extension Rule {
//    
//    public var type : RuleType {
//        get {
//            return ProxyRuleType(rawValue: typeRaw) ?? .DomainSuffix
//        }
//        set(v) {
//            typeRaw = v.rawValue
//        }
//    }
//    
//    public var action : RuleAction {
//        let json = content.jsonDictionary()
//        if let raw = json?[ruleActionKey] as? String {
//            return RuleAction(rawValue: raw) ?? .Proxy
//        }
//        return .Proxy
//    }
//    
//    public var value : String {
//        let json = content.jsonDictionary()
//        return json?[ruleValueKey] as? String ?? ""
//    }
//
//}
//
public final class Rule {

    public var type: ProxyRuleType
    public var value: String
    public var action: RuleAction
    
    public convenience init(str: String) throws {
        var ruleStr = str.replacingOccurrences(of: "\t", with: "")
        ruleStr = ruleStr.replacingOccurrences(of: " ", with: "")
        let parts = ruleStr.components(separatedBy: ",")
        guard parts.count >= 3 else {
            throw RuleError.invalidRule(str)
        }
        let actionStr = parts[2].uppercased()
        let typeStr = parts[0].uppercased()
        let value = parts[1]
        guard let type = ProxyRuleType(rawValue: typeStr), let action = RuleAction(rawValue: actionStr), value.count > 0 else {
            throw RuleError.invalidRule(str)
        }
        self.init(type: type, action: action, value: value)
    }
    
    public init(type: ProxyRuleType, action: RuleAction, value: String) {
        self.type = type
        self.value = value
        self.action = action
    }

    public convenience init?(json: [String: AnyObject]) {
        guard let typeRaw = json["type"] as? String, let type = ProxyRuleType(rawValue: typeRaw) else {
            return nil
        }
        guard let actionRaw = json["action"] as? String, let action = RuleAction(rawValue: actionRaw) else {
            return nil
        }
        guard let value = json["value"] as? String else {
            return nil
        }
        self.init(type: type, action: action, value: value)
    }

    public var description: String {
        return "\(type), \(value), \(action)"
    }

    public var json: [String: AnyObject] {
        return ["type": type.rawValue as AnyObject, "value": value as AnyObject, "action": action.rawValue as AnyObject]
    }
}
//
//
//public func ==(lhs: Rule, rhs: Rule) -> Bool {
//    return lhs.uuid == rhs.uuid
//}
