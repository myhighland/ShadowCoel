//
//  Proxy.swift
//  ShadowCoel
//
//  Created by Coel on 2019/4/24.
//  Copyright © 2019 Coel Wu. All rights reserved.
//

import RealmSwift
import CloudKit

public enum ProxyType: String {
    case Shadowsocks = "Shadowsocks"
    case ShadowsocksR = "ShadowsocksR"
    case V2ray = "V2ray"
    case Trojan = "Trojan"
    case GfwPress = "GFW.Press"
    case Http = "HTTP"
    case Https = "HTTPS"
    case Http2 = "HTTP2"
    case SSH = "SSH"
    case Socks4 = "Socks4"
    case Socks4a = "Socks4a"
    case Socks5 = "Socks5"
    case Socks5OverTls = "Socks5OverTLS"
    case Sni = "SNI"
    case Quic = "QUIC"
    case None = "None"
}

extension ProxyType: CustomStringConvertible {
    
    public var description: String {
        return rawValue
    }
    
    public var isShadowsocks: Bool {
        return self == .Shadowsocks || self == .ShadowsocksR
    }
    
    public var isV2ray: Bool {
        return self == .V2ray
    }
}

public enum ProxyError: Error {
    case invalidType
    case invalidName
    case invalidHost
    case invalidPort
    case invalidAuthScheme
    case nameAlreadyExists
    case invalidUri
    case invalidPassword
}

open class Proxy: BaseModel {
    @objc open dynamic var typeRaw = ProxyType.Shadowsocks.rawValue
    @objc open dynamic var name = "" // 服务器名称
    @objc open dynamic var host = "" // 服务器地址
    @objc open dynamic var port = 0 // 端口
    @objc open dynamic var authentication: String? // gost验证方法
    @objc open dynamic var networkmethod: String? // v2ray网络传输协议
    @objc open dynamic var authscheme: String?  // ss,ssr,v2ray加密方式
    @objc open dynamic var unsafeconnection: Bool = false // 允许不安全连接
    @objc open dynamic var user: String? // 用户
    @objc open dynamic var password: String? // 密码(所有协议通用)(v2ray除外)
    @objc open dynamic var ota: Bool = false // 一次性验证,已废弃
    @objc open dynamic var ssrProtocol: String? // ssr协议
    @objc open dynamic var ssrProtocolParam: String? // ssr协议参数
    @objc open dynamic var ssrObfs: String? // ssr混淆
    @objc open dynamic var ssrObfsParam: String? // ssr混淆参数
    @objc open dynamic var tcpheadertype: String? // V2ray TCP类型
    @objc open dynamic var tcphttphost: String? // V2ray TCP Httpx混淆域名
    @objc open dynamic var mkcpmtu = 1350 // V2ray mKCP MTU
    @objc open dynamic var mkcptti = 50 // V2ray mKCP TTI
    @objc open dynamic var mkcpulc = 5 // V2ray Up Link Capacity
    @objc open dynamic var mkcpdlc = 20 // V2ray Down Link Capacity
    @objc open dynamic var mkcpcongestion: Bool = false // V2ray 拥塞控制
    @objc open dynamic var mkcprbs = 1 // V2ray Read Buffer Size
    @objc open dynamic var mkcpwbs = 1 // V2ray Write Buffer Size
    @objc open dynamic var mkcpheadertype: String? // V2ray mKCP包头类型
    @objc open dynamic var wspath: String? // V2ray WebSocket路径
    @objc open dynamic var wshost: String? // V2ray Websocket域名
    @objc open dynamic var httphost: String? // V2ray HTTP域名
    @objc open dynamic var httppath: String? // V2ray HTTP路径
    @objc open dynamic var quicsecurity: String? // V2ray QUIC加密方式
    @objc open dynamic var quickey: String? // V2ray QUIC密钥
    @objc open dynamic var quicheadertype: String? // V2ray QUIC包头类型

    public static let ssUriPrefix = "ss://" // ss链接
    public static let ssrUriPrefix = "ssr://" // ssr链接
    
    // v2ray传输方式
    public static let v2rayNetworkMethod = [
    "tcp",
    "mkcp",
    "ws",
    "http",
    // "ds", (工作中) // Domain Socket
    "quic"
    ]
    
    // V2ray TCP头类型
    public static let v2rayTcpHeaderType = [
        "none",
        "http"
    ]
    
    // v2ray加密方式
    public static let v2raySupportedEncryption = [
        "auto",
        "aes-128-gcm",
        "chacha20-poly1305",
        "none"
    ]
    
    // V2ray MKcp头类型
    public static let v2rayMKcpHeaderType = [
        "none",
        "srtp",
        "utp",
        "wechat-video",
        "dtls",
        "wireguard"
    ]
    
    // V2ray Quic头类型
    public static let v2rayQuicHeaderType = Proxy.v2rayMKcpHeaderType
    
    // V2ray Quic加密类型
    public static let v2rayQuiSecurity = [
    "none",
    "aes-128-gcm",
    "chacha20-poly1305"
    ]
    
    // ssr协议
    public static let ssrSupportedProtocol = [
        "origin",
        "verify_simple",
        // "verify_sha1", (已废弃)
        "auth_simple",
        "auth_sha1",
        "auth_sha1_v2",
        "auth_sha1_v4",
        "auth_aes128_sha1",
        "auth_aes128_md5",
        "auth_chain_a",
        "auth_chain_b",
        "auth_chain_c",
        "auth_chain_d",
        "auth_chain_e",
        "auth_chain_f"
    ]
    
    // ssr混淆
    public static let ssrSupportedObfs = [
        "plain",
        "http_simple",
        "http_post",
        "http_mix",
        // "tls1.0_session_auth", (已废弃)
        "tls1.2_ticket_auth",
        "tls1.2_ticket_fastauth"
    ]
    
    // ss,ssr加密
    public static let ssSupportedEncryption = [
        "none",
        "table",
        "rc4",
        "rc4-md5",
        "aes-128-cfb",
        "aes-192-cfb",
        "aes-256-cfb",
        "bf-cfb",
        "camellia-128-cfb",
        "camellia-192-cfb",
        "camellia-256-cfb",
        "cast5-cfb",
        "des-cfb",
        "idea-cfb",
        "rc2-cfb",
        "seed-cfb",
        "salsa20",
        "chacha20",
        "chacha20-ietf"
]
}

// Public Accessor
extension Proxy {
    
    public var type: ProxyType {
        get {
            return ProxyType(rawValue: typeRaw) ?? .Shadowsocks
        }
        set(v) {
            typeRaw = v.rawValue
        }
    }
    
    open func Uri() -> String {
        switch type {
        // ss链接
        case .Shadowsocks:
            if let authscheme = authscheme,
                let password = password,
                let ss = "\(authscheme):\(password)@\(host):\(port)".data(using: .ascii)
            {
                return "ss://" + ss.base64EncodedString()
            }
            return ""
        // ssr链接
        case .ShadowsocksR:
            if let ssrProtocol = ssrProtocol,
                let authscheme = authscheme,
                let ssrObfs = ssrObfs,
                let password = password,
                let ssrObfsParam = ssrObfsParam,
                let ssrProtocolParam = ssrProtocolParam,
                let name = Optional(name)
            {
                let password_base64 = password.data(using: .ascii)?.base64EncodedString()
                let password_base64_1 = password_base64!.replacingOccurrences(of: "=", with: "")
                let password_base64_2 = password_base64_1.replacingOccurrences(of: "/", with: "_")
                let ssrObfsParam_base64 = ssrObfsParam.data(using: .ascii)?.base64EncodedString()
                let ssrObfsParam_base64_1 = ssrObfsParam_base64!.replacingOccurrences(of: "=", with: "")
                let ssrObfsParam_base64_2 = ssrObfsParam_base64_1.replacingOccurrences(of: "/", with: "_")
                let ssrProtocolParam_base64 = ssrProtocolParam.data(using: .ascii)?.base64EncodedString()
                let ssrProtocolParam_base64_1 = ssrProtocolParam_base64!.replacingOccurrences(of: "=", with: "")
                let ssrProtocolParam_base64_2 = ssrProtocolParam_base64_1.replacingOccurrences(of: "/", with: "_")
                let name_base64 = name.data(using: .ascii)?.base64EncodedString()
                let name_base64_1 = name_base64!.replacingOccurrences(of: "=", with: "")
                let name_base64_2 = name_base64_1.replacingOccurrences(of: "/", with: "_")
                let param_base64 = "obfsparam=\(ssrObfsParam_base64_2)&protoparam=\(ssrProtocolParam_base64_2)&remarks=\(name_base64_2)"
                var ssr = "\(host):\(port):\(ssrProtocol):\(authscheme):\(ssrObfs):\(password_base64_2)/?\(param_base64)".data(using: .ascii)?.base64EncodedString()
                let ssr_1 = ssr!.replacingOccurrences(of: "=", with: "")
                let ssr_2 = ssr_1.replacingOccurrences(of: "/", with: "_")
                return "ssr://" + ssr_2
            }
            
        default:
            break
        }
        return ""
    }
    open override var description: String {
        return name
    }
    
}

// Import
extension Proxy {
    
    public convenience init(dictionary: [String: AnyObject], inRealm realm: Realm) throws {
        self.init()
        if let uriString = dictionary["uri"] as? String {
            guard let name = dictionary["name"] as? String else{
                throw ProxyError.invalidName
            }
            self.name = name
            if uriString.lowercased().hasPrefix(Proxy.ssUriPrefix) {
                // Shadowsocks
                let undecodedString = uriString.substring(from: uriString.index(uriString.startIndex, offsetBy: Proxy.ssUriPrefix.count))
                guard let proxyString = base64DecodeIfNeeded(undecodedString), let _ = proxyString.range(of: ":")?.lowerBound else {
                    throw ProxyError.invalidUri
                }
                guard let pc1 = proxyString.range(of: ":")?.lowerBound, let pc2 = proxyString.range(of: ":", options: .backwards)?.lowerBound, let pcm = proxyString.range(of: "@", options: .backwards)?.lowerBound else {
                    throw ProxyError.invalidUri
                }
                if !(pc1 < pcm && pcm < pc2) {
                    throw ProxyError.invalidUri
                }
                let fullAuthscheme = proxyString.lowercased().substring(with: proxyString.startIndex..<pc1)
                if let pOTA = fullAuthscheme.range(of: "-auth", options: .backwards)?.lowerBound {
                    self.authscheme = fullAuthscheme.substring(to: pOTA)
                    self.ota = true
                }else {
                    self.authscheme = fullAuthscheme
                }
                self.password = proxyString.substring(with: proxyString.index(after: pc1)..<pcm)
                self.host = proxyString.substring(with: proxyString.index(after: pcm)..<pc2)
                guard let p = Int(proxyString.substring(with: proxyString.index(after: pc2)..<proxyString.endIndex)) else {
                    throw ProxyError.invalidPort
                }
                self.port = p
                self.type = .Shadowsocks
            }else if uriString.lowercased().hasPrefix(Proxy.ssrUriPrefix) {
                // ShadowsocksR
                let undecodedString = uriString.substring(from: uriString.characters.index(uriString.startIndex, offsetBy: Proxy.ssrUriPrefix.characters.count))
                guard let proxyString = base64DecodeIfNeeded(undecodedString), let _ = proxyString.range(of: ":")?.lowerBound else {
                    throw ProxyError.invalidUri
                }
                var hostString: String = proxyString
                var queryString: String = ""
                if let queryMarkIndex = proxyString.range(of: "?", options: .backwards)?.lowerBound {
                    hostString = proxyString.substring(to: queryMarkIndex)
                    queryString = proxyString.substring(from: proxyString.index(after: queryMarkIndex))
                }
                if let hostSlashIndex = hostString.range(of: "/", options: .backwards)?.lowerBound {
                    hostString = hostString.substring(to: hostSlashIndex)
                }
                let hostComps = hostString.components(separatedBy: ":")
                guard hostComps.count == 6 else {
                    throw ProxyError.invalidUri
                }
                self.host = hostComps[0] // 服务器地址
                guard let p = Int(hostComps[1]) else {
                    throw ProxyError.invalidPort
                }
                self.port = p // 端口
                self.ssrProtocol = hostComps[2] // ssr协议
                self.authscheme = hostComps[3] // ss,ssr加密方式
                self.ssrObfs = hostComps[4] // ssr混淆
                self.password = base64DecodeIfNeeded(hostComps[5]) // ss,ssr密码
                for queryComp in queryString.components(separatedBy: "&") {
                    let comps = queryComp.components(separatedBy: "=")
                    guard comps.count == 2 else {
                        continue
                    }
                    switch comps[0] {
                    case "obfsparam":
                        self.ssrObfsParam = base64DecodeIfNeeded(comps[1]) // ssr混淆参数
                    case "protoparam":
                        self.ssrProtocolParam = base64DecodeIfNeeded(comps[1]) // ssr协议参数
                    case "remarks":
                        self.name = base64DecodeIfNeeded(comps[1])! // ssr备注
                    default:
                        continue
                    }
                }
                self.type = .ShadowsocksR
            }else {
                // Not supported yet
                throw ProxyError.invalidUri
            }
        }else {
            guard let name = dictionary["name"] as? String else{
                throw ProxyError.invalidName
            }
            guard let host = dictionary["host"] as? String else{
                throw ProxyError.invalidHost
            }
            guard let typeRaw = (dictionary["type"] as? String)?.uppercased(), let type = ProxyType(rawValue: typeRaw) else{
                throw ProxyError.invalidType
            }
            guard let portStr = (dictionary["port"] as? String), let port = Int(portStr) else{
                throw ProxyError.invalidPort
            }
            guard let encryption = dictionary["encryption"] as? String else{
                throw ProxyError.invalidAuthScheme
            }
            guard let password = dictionary["password"] as? String else{
                throw ProxyError.invalidPassword
            }
            self.host = host
            self.port = port
            self.password = password
            self.authscheme = encryption
            self.name = name
            self.type = type
        }
        if realm.objects(Proxy.self).filter("name = '\(name)'").first != nil {
            self.name = "\(name) \(Proxy.dateFormatter.string(from: Date()))"
        }
        try validate(inRealm: realm)
    }
    
    fileprivate func base64DecodeIfNeeded(_ proxyString: String) -> String? {
        if let _ = proxyString.range(of: ":")?.lowerBound {
            return proxyString
        }
        let base64String = proxyString.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
        let padding = base64String.count + (base64String.count % 4 != 0 ? (4 - base64String.count % 4) : 0)
        if let decodedData = Data(base64Encoded: base64String.padding(toLength: padding, withPad: "=", startingAt: 0), options: NSData.Base64DecodingOptions(rawValue: 0)), let decodedString = NSString(data: decodedData, encoding: String.Encoding.utf8.rawValue) {
            return decodedString as String
        }
        return nil
    }
    
    public class func uriIsShadowsocks(_ uri: String) -> Bool {
        return uri.lowercased().hasPrefix(Proxy.ssUriPrefix) || uri.lowercased().hasPrefix(Proxy.ssrUriPrefix)
    }
    
}

