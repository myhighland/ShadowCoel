//
//  UrlHandler.swift
//  ShadowCoel
//
//  Created by Coel on 2019/4/25.
//  Copyright © 2019 Coel Wu. All rights reserved.
//

import Foundation
import ICSMainFramework
import ShadowCoelLibrary
import Async
import CallbackURLKit
typealias callbackURLKit_Manager = CallbackURLKit.Manager

class UrlHandler: NSObject, AppLifeCycleProtocol {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let manager = callbackURLKit_Manager.shared
        manager.callbackURLScheme = callbackURLKit_Manager.urlSchemes?.first
        for action in [URLAction.CONNECT, URLAction.OPEN, URLAction.DISCONNECT, URLAction.CLOSE, URLAction.TOGGLE] {
            manager[action.rawValue] = { parameters, success, failure, cancel in
                action.perform(nil, parameters: parameters) { error in
                    Async.main(after: 1, {
                        if let error = error {
                            _ = failure(error as NSError)
                        }else {
                            _ = success(nil)
                        }
                    })
                    return
                }
            }
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var parameters: Parameters = [:]
        components?.queryItems?.forEach {
            guard let _ = $0.value else {
                return
            }
            parameters[$0.name] = $0.value
        }
        if let host = url.host {
            return dispatchAction(url, actionString: host, parameters: parameters)
        }
        return false
    }
    
    func dispatchAction(_ url: URL?, actionString: String, parameters: Parameters) -> Bool {
        guard let action = URLAction(rawValue: actionString) else {
            return false
        }
        return action.perform(url, parameters: parameters)
    }
    
}

enum URLAction: String {
    
    case CONNECT = "connect" // 开启
    case OPEN = "open" // 开启
    case DISCONNECT = "disconnect" // 关闭
    case CLOSE = "close" // 关闭
    case TOGGLE = "toggle" // 切换
    case XCALLBACK = "x-callback-url"
    
    func perform(_ url: URL?, parameters: Parameters, completion: ((Error?) -> Void)? = nil) -> Bool {
        switch self {
        case .CONNECT,.OPEN:
            Manager.sharedManager.startVPN({ (manager, error) in
                if error == nil {
                    self.autoClose(parameters)
                }
                completion?(error)
            })
        case .DISCONNECT,.CLOSE:
            Manager.sharedManager.stopVPN()
            autoClose(parameters)
            completion?(nil)
        case .TOGGLE:
            Manager.sharedManager.switchVPN({ (manager, error) in
                if error == nil {
                    self.autoClose(parameters)
                }
                completion?(error)
            })
        case .XCALLBACK:
            if let url = url {
                return callbackURLKit_Manager.shared.handleOpen(url: url)
            }
        }
        return true
    }
    
    func autoClose(_ parameters: Parameters) {
        var autoclose = false
        if let value = parameters["autoclose"], value.lowercased() == "true" || value.lowercased() == "1" {
            autoclose = true
        }
        if autoclose {
            Async.main(after: 1, {
                UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            })
        }
    }
    
}
