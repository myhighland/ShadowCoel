//
//  SubscribeManager.swift
//  ShadowCoel
//
//  Created by Coel on 2019/6/5.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Alamofire
import ICSMainFramework

class SubscribeManager {
    
    open func updateSubscribe(url: String) {
        sendRequest(url: url, callback: { resString in
            if resString == "" { return }
            self.updateServers(resString: resString)
        })
    }
    
    // 发送订阅请求
    open func sendRequest(url: String, callback: @escaping (String) -> Void) {
        let headers: HTTPHeaders = [
            "User-Agent": "ShadowCoel "  + "Version " + (AppEnv.fullVersion)
        ]
        Alamofire.request(url, headers: headers)
            .responseString{
                response in
                if response.result.isSuccess {
                    callback(response.result.value!)
                } else {
                    callback("")
                }
        }
    }
    
    open func updateServers(resString: String) {
        do {
            let res = self.base64DecodeIfNeeded(resString)
            let urls = res!.split(separator: "\n")
            let defaultName = "___subscribe"
            let proxies = DBUtils.allNotDeleted(Proxy.self, sorted: "createAt").map({ $0 })
            var isExist = false
            for url in urls {
                isExist = false
                let urlt = try Proxy(dictionary: ["name": defaultName as AnyObject, "uri": url as AnyObject], inRealm: defaultRealm)
                for proxy in proxies {
                    if urlt.group == proxy.group && urlt.host == proxy.host && urlt.port == proxy.port{
                        modifyproxy(proxy1: urlt,proxy2: proxy)
                        isExist = true
                    }
                }
                if !isExist {
                    addproxy(proxy: urlt)
                }
            }
        }catch {
            DDLogError("[-] Update Server Failed")
        }
    }
    
    open func addproxy(proxy: Proxy) {
        do {
            let temp = Proxy()
            temp.type = ProxyType.ShadowsocksR
            temp.group = proxy.group
            temp.name = proxy.name
            temp.host = proxy.host
            temp.port = proxy.port
            temp.password = proxy.password
            temp.authscheme = proxy.authscheme
            temp.ssrProtocol = proxy.ssrProtocol
            temp.ssrProtocolParam = proxy.ssrProtocolParam
            temp.ssrObfs = proxy.ssrObfs
            temp.ssrObfsParam = proxy.ssrObfsParam
            let IPLO = IPLocation()
            temp.country = IPLO.IP2CountryCode(IP: proxy.host)
            try DBUtils.add(temp)
        }catch {
            DDLogError("[-] Add Prxoy Failed")
        }
    }
    
    open func modifyproxy(proxy1: Proxy,proxy2: Proxy) {
        do {
            let temp = Proxy()
            temp.type = ProxyType.ShadowsocksR
            temp.group = proxy1.group
            temp.name = proxy1.name
            temp.host = proxy1.host
            temp.port = proxy1.port
            temp.password = proxy1.password
            temp.authscheme = proxy1.authscheme
            temp.ssrProtocol = proxy1.ssrProtocol
            temp.ssrProtocolParam = proxy1.ssrProtocolParam
            temp.ssrObfs = proxy1.ssrObfs
            temp.ssrObfsParam = proxy1.ssrObfsParam
            try DBUtils.hardDelete(proxy2.uuid, type: Proxy.self)
            try DBUtils.add(temp)
        }catch {
            print("[-] Modify Proxy Failed")
        }
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
    
}
