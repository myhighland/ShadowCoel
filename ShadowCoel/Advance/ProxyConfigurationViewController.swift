//
//  ProxyConfigurationViewController.swift
//  ShadowCoel
//
//  Created by Coel on 2019/4/24.
//  Copyright © 2019 Coel Wu. All rights reserved.
//

import UIKit
import Eureka
import ShadowCoelLibrary
import ShadowCoelModel

public enum ProxyConfigurationError: Error {
    case Error(String)
}

private let kProxyFormType = "type"
private let KProxyFormCountry = "country"
private let kProxyFormName = "name"
private let kProxyFormHost = "host"
private let kProxyFormPort = "port"
private let kProxyFormEncryption = "encryption"
private let kProxyFormUsername = "username"
private let kProxyFormPassword = "password"
private let kProxyFormNetworkMethod = "networkmethod"
private let kProxyFormOta = "ota"
private let kProxyFormProtocol = "protocol"
private let kProxyFormProtocolParam = "protocolParam"
private let kProxyFormObfs = "obfs"
private let kProxyFormObfsParam = "obfsParam"
private let kProxyFormTcpHeader = "tcpheader"
private let kProxyFormTcpHttpHost = "tcphttphost"
private let kProxyFormMKcpMtu = "mkcpmtu"
private let kProxyFormMKcpTTI = "mkcptti"
private let kProxyFormMKcpULC = "mkcpulc"
private let kProxyFormMKcpDLC = "mkcpdlc"
private let kProxyFormMKcpCongestion = "mkcpcongestion"
private let kProxyFormMKcpRBS = "mkcprbs"
private let kProxyFormMKcpWBS = "mkcpwbs"
private let kProxyFormMKcpHeader = "mkcpheader"
private let kProxyFormWSPath = "wspath"
private let kProxyFormWSHost = "wshost"
private let kProxyFormHttpHost = "httphost"
private let kProxyFormHttpPath = "httppath"
private let kProxyFormQuicSecurity = "quicsecurity"
private let kProxyFormQuicKey = "quickey"
private let kProxyFormQuicHeader = "quicheader"

class ProxyConfigurationViewController: FormViewController {
    
    var upstreamProxy: Proxy
    let isEdit: Bool
    
    override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init()
    }
    
    init(upstreamProxy: Proxy? = nil) {
        if let proxy = upstreamProxy {
            self.upstreamProxy = Proxy(value: proxy)
            self.isEdit = true
        }else {
            self.upstreamProxy = Proxy()
            self.isEdit = false
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEdit {
            self.navigationItem.title = "Edit Proxy".localized()
        }else {
            self.navigationItem.title = "Add Proxy".localized()
        }
        generateForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
    }
    
    func generateForm() {
        form +++ Section()
            <<< PushRow<ProxyType>(kProxyFormType) {
                $0.title = "Proxy Type".localized()
                $0.options = [ProxyType.Shadowsocks, ProxyType.ShadowsocksR, ProxyType.V2ray, ProxyType.Trojan, ProxyType.GfwPress, ProxyType.Http, ProxyType.Https, ProxyType.Http2, ProxyType.SSH, ProxyType.Socks4, ProxyType.Socks4a, ProxyType.Socks5, ProxyType.Socks5OverTls, ProxyType.Sni,ProxyType.Quic]
                $0.value = self.upstreamProxy.type
                $0.selectorTitle = "Choose Proxy Type".localized()
                }.onChange { row in
                    if let ProxyFormEncryption = self.form.rowBy(tag: kProxyFormEncryption) as? PushRow<String> {
                        if (row.value?.isShadowsocks == true) {
                            ProxyFormEncryption.options = Proxy.ssSupportedEncryption
                        } else if (row.value?.isV2ray == true) {
                             ProxyFormEncryption.options = Proxy.v2raySupportedEncryption
                        }
                    }
            }
        form +++ Section()
            <<< PushRow<String>(KProxyFormCountry) {
                $0.title = "Country"
            }
        form +++ Section()
            <<< TextRow(kProxyFormName) {
                $0.title = "Name".localized()
                $0.value = self.upstreamProxy.name
                }.cellSetup { cell, row in
                    cell.textField.placeholder = "Proxy Name".localized()
            }
            <<< TextRow(kProxyFormHost) {
                $0.title = "Host".localized()
                $0.value = self.upstreamProxy.host
                }.cellSetup { cell, row in
                    cell.textField.placeholder = "Proxy Server Host".localized()
                    cell.textField.keyboardType = .URL
                    cell.textField.autocorrectionType = .no
                    cell.textField.autocapitalizationType = .none
            }
            <<< IntRow(kProxyFormPort) {
                $0.title = "Port".localized()
                if self.upstreamProxy.port > 0 {
                    $0.value = self.upstreamProxy.port
                }
                let numberFormatter = NumberFormatter()
                numberFormatter.locale = .current
                numberFormatter.numberStyle = .none
                numberFormatter.minimumFractionDigits = 0
                $0.formatter = numberFormatter
                }.cellSetup { cell, row in
                    cell.textField.placeholder = "Proxy Server Port".localized()
            }
            <<< PasswordRow(kProxyFormPassword) {
                $0.title = "Password".localized()
                $0.value = self.upstreamProxy.password ?? nil
                }.cellSetup { cell, row in
                    cell.textField.placeholder = "Proxy Password".localized()
            }
            <<< PushRow<String>(kProxyFormEncryption) {
                $0.title = "Encryption".localized()
                $0.options = Proxy.ssSupportedEncryption
                $0.value = self.upstreamProxy.authscheme
                $0.selectorTitle = "Choose encryption method".localized()
                $0.hidden = Condition.function([kProxyFormType]) { form in
                    if let r1 : PushRow<ProxyType> = form.rowBy(tag: kProxyFormType), let isSS = r1.value?.isShadowsocks, let isV2ray = r1.value?.isV2ray {
                        return !isSS && !isV2ray
                    }
                    return false
                }
            }
            <<< PushRow<String>(kProxyFormNetworkMethod) {
                $0.title = "Network".localized()
                $0.options = Proxy.v2rayNetworkMethod
                $0.value = self.upstreamProxy.networkmethod
                $0.selectorTitle = "Choose Network Method".localized()
                $0.hidden = Condition.function([kProxyFormType]) { form in
                    if let r1 : PushRow<ProxyType> = form.rowBy(tag: kProxyFormType) {
                        return r1.value != ProxyType.V2ray
                    }
                    return false
                }
                }.onChange { row in
                    if (row.value! == "tcp") {
                        self.showv2raytcp()
                        self.hidev2raymkcp()
                        self.hidev2rayws()
                        self.hidev2rayhttp()
                        self.hidev2rayquic()
                    } else if (row.value! == "mkcp") {
                        self.hidev2raytcp()
                        self.showv2raymkcp()
                        self.hidev2rayws()
                        self.hidev2rayhttp()
                        self.hidev2rayquic()
                    } else if (row.value! == "ws") {
                        self.hidev2raytcp()
                        self.hidev2raymkcp()
                        self.showv2rayws()
                        self.hidev2rayhttp()
                        self.hidev2rayquic()
                    } else if (row.value! == "http") {
                        self.hidev2raytcp()
                        self.hidev2raymkcp()
                        self.hidev2rayws()
                        self.showv2rayhttp()
                        self.hidev2rayquic()
                    } else if (row.value! == "quic") {
                        self.hidev2raytcp()
                        self.hidev2raymkcp()
                        self.hidev2rayws()
                        self.hidev2rayhttp()
                        self.showv2rayquic()
                    }
            }
            <<< SwitchRow(kProxyFormOta) {
                $0.title = "One Time Auth".localized()
                $0.value = self.upstreamProxy.ota
                $0.hidden = Condition.function([kProxyFormType]) { form in
                    if let r1 : PushRow<ProxyType> = form.rowBy(tag: kProxyFormType) {
                        return r1.value != ProxyType.Shadowsocks
                    }
                    return false
                }
            }
            <<< PushRow<String>(kProxyFormProtocol) {
                $0.title = "Protocol".localized()
                $0.value = self.upstreamProxy.ssrProtocol
                $0.options = Proxy.ssrSupportedProtocol
                $0.selectorTitle = "Choose SSR protocol".localized()
                $0.hidden = Condition.function([kProxyFormType]) { form in
                    if let r1 : PushRow<ProxyType> = form.rowBy(tag: kProxyFormType) {
                        return r1.value != ProxyType.ShadowsocksR
                    }
                    return false
                }
            }
            <<< TextRow(kProxyFormProtocolParam) {
                $0.title = "Protocol Param".localized()
                $0.value = self.upstreamProxy.ssrProtocolParam
                $0.hidden = Condition.function([kProxyFormType]) { form in
                    if let r1 : PushRow<ProxyType> = form.rowBy(tag: kProxyFormType) {
                        return r1.value != ProxyType.ShadowsocksR
                    }
                    return false
                }
                }.cellSetup { cell, row in
                    cell.textField.placeholder = "SSR Protocol Param".localized()
                    cell.textField.autocorrectionType = .no
                    cell.textField.autocapitalizationType = .none
        }
            <<< PushRow<String>(kProxyFormObfs) {
                $0.title = "Obfs".localized()
                $0.value = self.upstreamProxy.ssrObfs
                $0.options = Proxy.ssrSupportedObfs
                $0.selectorTitle = "Choose SSR obfs".localized()
                $0.hidden = Condition.function([kProxyFormType]) { form in
                    if let r1 : PushRow<ProxyType> = form.rowBy(tag: kProxyFormType) {
                        return r1.value != ProxyType.ShadowsocksR
                    }
                    return false
                }
            }
            <<< TextRow(kProxyFormObfsParam) {
                $0.title = "Obfs Param".localized()
                $0.value = self.upstreamProxy.ssrObfsParam
                $0.hidden = Condition.function([kProxyFormType]) { form in
                    if let r1 : PushRow<ProxyType> = form.rowBy(tag: kProxyFormType) {
                        return r1.value != ProxyType.ShadowsocksR
                    }
                    return false
                }
                }.cellSetup { cell, row in
                    cell.textField.placeholder = "SSR Obfs Param".localized()
                    cell.textField.autocorrectionType = .no
                    cell.textField.autocapitalizationType = .none
        }
            <<< PushRow<String>(kProxyFormTcpHeader) {
                $0.title = "Header Type"
                $0.options = Proxy.v2rayTcpHeaderType
                $0.hidden = true
                $0.value = self.upstreamProxy.tcpheadertype
        }
            <<< TextRow(kProxyFormTcpHttpHost) {
                $0.title = "HTTP Host"
                $0.value = self.upstreamProxy.tcphttphost
                $0.hidden = true
            }
            <<< IntRow(kProxyFormMKcpMtu) {
                $0.title = "MTU".localized()
                $0.value = self.upstreamProxy.mkcpmtu
                $0.hidden = true
                let numberFormatter = NumberFormatter()
                numberFormatter.locale = .current
                numberFormatter.numberStyle = .none
                numberFormatter.minimumFractionDigits = 0
                $0.formatter = numberFormatter
                }.cellSetup { cell, row in
                    cell.textField.placeholder = "MTU".localized()
            }
            <<< IntRow(kProxyFormMKcpTTI) {
                $0.title = "TTI".localized()
                $0.value = self.upstreamProxy.mkcptti
                $0.hidden = true
                let numberFormatter = NumberFormatter()
                numberFormatter.locale = .current
                numberFormatter.numberStyle = .none
                numberFormatter.minimumFractionDigits = 0
                $0.formatter = numberFormatter
                }.cellSetup { cell, row in
                    cell.textField.placeholder = "TTI".localized()
            }
            <<< IntRow(kProxyFormMKcpULC) {
                $0.title = "Up Link Capacity".localized()
                $0.value = self.upstreamProxy.mkcpulc
                $0.hidden = true
                let numberFormatter = NumberFormatter()
                numberFormatter.locale = .current
                numberFormatter.numberStyle = .none
                numberFormatter.minimumFractionDigits = 0
                $0.formatter = numberFormatter
                }.cellSetup { cell, row in
                    cell.textField.placeholder = "Up Link Capacity".localized()
            }
            <<< IntRow(kProxyFormMKcpDLC) {
                $0.title = "Down Link Capacity".localized()
                $0.value = self.upstreamProxy.mkcpdlc
                $0.hidden = true
                let numberFormatter = NumberFormatter()
                numberFormatter.locale = .current
                numberFormatter.numberStyle = .none
                numberFormatter.minimumFractionDigits = 0
                $0.formatter = numberFormatter
                }.cellSetup { cell, row in
                    cell.textField.placeholder = "Up Link Capacity".localized()
            }
            <<< SwitchRow(kProxyFormMKcpCongestion) {
                $0.title = "Congestion".localized()
                $0.value = self.upstreamProxy.mkcpcongestion
                $0.hidden = true
            }
            <<< IntRow(kProxyFormMKcpRBS) {
                $0.title = "Read Buffer Size"
                $0.value = self.upstreamProxy.mkcprbs
                $0.hidden = true
            }
            <<< IntRow(kProxyFormMKcpWBS) {
                $0.title = "Write Buffer Size"
                $0.value = self.upstreamProxy.mkcpwbs
                $0.hidden = true
            }
            <<< PushRow<String>(kProxyFormMKcpHeader) {
                $0.title = "Header Type"
                $0.options = Proxy.v2rayMKcpHeaderType
                $0.value = self.upstreamProxy.mkcpheadertype
                $0.hidden = true
        }
            <<< TextRow(kProxyFormWSPath) {
                $0.title = "WS Path"
                $0.value = self.upstreamProxy.wspath
                $0.hidden = true
            }
            <<< TextRow(kProxyFormWSHost) {
                $0.title = "WS Host"
                $0.value = self.upstreamProxy.wshost
                $0.hidden = true
            }
            <<< TextRow(kProxyFormHttpHost) {
                $0.title = "HTTP Host".localized()
                $0.value = self.upstreamProxy.httphost
                $0.hidden = true
                }.cellSetup { cell, row in
                    cell.textField.placeholder = "Proxy Name".localized()
        }
            <<< TextRow(kProxyFormHttpPath) {
                $0.title = "HTTP Path".localized()
                $0.value = self.upstreamProxy.httppath
                $0.hidden = true
                }.cellSetup { cell, row in
                    cell.textField.placeholder = "Proxy Name".localized()
        }
            <<< PushRow<String>(kProxyFormQuicSecurity) {
                $0.title = "Security".localized()
                $0.value = self.upstreamProxy.quicsecurity
                $0.hidden = true
                $0.options = Proxy.ssrSupportedObfs
                $0.selectorTitle = "Choose Method".localized()
            }
            <<< PasswordRow(kProxyFormQuicHeader) {
                $0.title = "Key".localized()
                $0.value = self.upstreamProxy.password ?? nil
                $0.hidden = true
                }.cellSetup { cell, row in
                    cell.textField.placeholder = "Quic Key".localized()
        }
            <<< PushRow<String>(kProxyFormQuicKey) {
                $0.title = "Header Type"
                $0.options = Proxy.v2rayQuicHeaderType
                $0.hidden = true
        }
        form +++ Section()
            <<< ActionRow() {
                $0.title = "Share QRCode"
                $0.hidden = Condition(booleanLiteral: !isEdit)
        }
            <<< ActionRow() {
                $0.title = "Share Url"
                $0.hidden = Condition(booleanLiteral: !isEdit)
                }.onCellSelection({ [unowned self] (cell, row) -> () in
                    self.shareuri()
                })
        form +++ Section()
            <<< ButtonRow() {
                $0.title = "Delete"
                $0.hidden = Condition(booleanLiteral: !isEdit)
        }.cellUpdate({ cell, row in
            cell.textLabel?.textColor = UIColor.red // 设置颜色为红色
        }).onCellSelection({ [unowned self] (cell, row) -> () in
                    self.deleteproxy()
        })
    }
    
    func showv2raytcp() {
        let ProxyFormTcpHeader = self.form.rowBy(tag: kProxyFormTcpHeader) as? PushRow<String>
        let ProxyFormTcpHttpHost = self.form.rowBy(tag: kProxyFormTcpHttpHost) as? TextRow
        ProxyFormTcpHeader?.hidden = false
        ProxyFormTcpHttpHost?.hidden = false
        ProxyFormTcpHeader?.evaluateHidden() // 必须运行此代码,否则无法显示
        ProxyFormTcpHttpHost?.evaluateHidden()
    }
    
    func showv2raymkcp() {
        let ProxyFormMKcpMtu = self.form.rowBy(tag: kProxyFormMKcpMtu) as? IntRow
        let ProxyFormMKcpTTI = self.form.rowBy(tag: kProxyFormMKcpTTI) as? IntRow
        let ProxyFormMKcpULC = self.form.rowBy(tag: kProxyFormMKcpULC) as? IntRow
        let ProxyFormMKcpDLC = self.form.rowBy(tag: kProxyFormMKcpDLC) as? IntRow
        let ProxyFormMKcpCongestion = self.form.rowBy(tag :kProxyFormMKcpCongestion) as? SwitchRow
        let ProxyFormMKcpRBS = self.form.rowBy(tag: kProxyFormMKcpRBS) as? IntRow
        let ProxyFormMKcpWBS = self.form.rowBy(tag: kProxyFormMKcpWBS) as? IntRow
        let ProxyFormMKcpHeader = self.form.rowBy(tag: kProxyFormMKcpHeader) as? PushRow<String>
        ProxyFormMKcpMtu?.hidden = false
        ProxyFormMKcpTTI?.hidden = false
        ProxyFormMKcpULC?.hidden = false
        ProxyFormMKcpDLC?.hidden = false
        ProxyFormMKcpCongestion?.hidden = false
        ProxyFormMKcpRBS?.hidden = false
        ProxyFormMKcpWBS?.hidden = false
        ProxyFormMKcpHeader?.hidden = false
        ProxyFormMKcpMtu?.evaluateHidden()
        ProxyFormMKcpTTI?.evaluateHidden()
        ProxyFormMKcpULC?.evaluateHidden()
        ProxyFormMKcpDLC?.evaluateHidden()
        ProxyFormMKcpCongestion?.evaluateHidden()
        ProxyFormMKcpRBS?.evaluateHidden()
        ProxyFormMKcpWBS?.evaluateHidden()
        ProxyFormMKcpHeader?.evaluateHidden()
    }
    
    func showv2rayws() {
        let ProxyFormWSPath = self.form.rowBy(tag: kProxyFormWSPath) as? TextRow
        let ProxyFormWSHost = self.form.rowBy(tag: kProxyFormWSHost) as? TextRow
        ProxyFormWSPath?.hidden = false
        ProxyFormWSHost?.hidden = false
        ProxyFormWSPath?.evaluateHidden()
        ProxyFormWSHost?.evaluateHidden()
    }
    
    func showv2rayhttp() {
        let ProxyFormHttpHost = self.form.rowBy(tag: kProxyFormHttpHost) as? TextRow
        let ProxyFormHttpPath = self.form.rowBy(tag: kProxyFormHttpPath) as? TextRow
        ProxyFormHttpHost?.hidden = false
        ProxyFormHttpPath?.hidden = false
        ProxyFormHttpHost?.evaluateHidden()
        ProxyFormHttpPath?.evaluateHidden()
    }
    
    func showv2rayquic() {
        let ProxyFormQuicSecurity = self.form.rowBy(tag: kProxyFormQuicSecurity) as? PushRow<String>
        let ProxyFormQuicKey = self.form.rowBy(tag: kProxyFormQuicKey) as? PasswordRow
        let ProxyFormQuicHeader = self.form.rowBy(tag: kProxyFormQuicHeader) as? PushRow<String>
        ProxyFormQuicSecurity?.hidden = false
        ProxyFormQuicKey?.hidden = false
        ProxyFormQuicHeader?.hidden = false
        ProxyFormQuicSecurity?.evaluateHidden()
        ProxyFormQuicKey?.evaluateHidden()
    }
    
    func hidev2raytcp() {
        let ProxyFormTcpHeader = self.form.rowBy(tag: kProxyFormTcpHeader) as? PushRow<String>
        let ProxyFormTcpHttpHost = self.form.rowBy(tag: kProxyFormTcpHttpHost) as? TextRow
        ProxyFormTcpHeader?.hidden = true
        ProxyFormTcpHttpHost?.hidden = true
        ProxyFormTcpHeader?.evaluateHidden()
        ProxyFormTcpHttpHost?.evaluateHidden()
    }
    
    func hidev2raymkcp() {
        let ProxyFormMKcpMtu = self.form.rowBy(tag: kProxyFormMKcpMtu) as? IntRow
        let ProxyFormMKcpTTI = self.form.rowBy(tag: kProxyFormMKcpTTI) as? IntRow
        let ProxyFormMKcpULC = self.form.rowBy(tag: kProxyFormMKcpULC) as? IntRow
        let ProxyFormMKcpDLC = self.form.rowBy(tag: kProxyFormMKcpDLC) as? IntRow
        let ProxyFormMKcpCongestion = self.form.rowBy(tag :kProxyFormMKcpCongestion) as? SwitchRow
        let ProxyFormMKcpRBS = self.form.rowBy(tag: kProxyFormMKcpRBS) as? IntRow
        let ProxyFormMKcpWBS = self.form.rowBy(tag: kProxyFormMKcpWBS) as? IntRow
        let ProxyFormMKcpHeader = self.form.rowBy(tag: kProxyFormMKcpHeader) as? PushRow<String>
        ProxyFormMKcpMtu?.hidden = true
        ProxyFormMKcpTTI?.hidden = true
        ProxyFormMKcpULC?.hidden = true
        ProxyFormMKcpDLC?.hidden = true
        ProxyFormMKcpCongestion?.hidden = true
        ProxyFormMKcpRBS?.hidden = true
        ProxyFormMKcpWBS?.hidden = true
        ProxyFormMKcpHeader?.hidden = true
        ProxyFormMKcpMtu?.evaluateHidden()
        ProxyFormMKcpTTI?.evaluateHidden()
        ProxyFormMKcpULC?.evaluateHidden()
        ProxyFormMKcpDLC?.evaluateHidden()
        ProxyFormMKcpCongestion?.evaluateHidden()
        ProxyFormMKcpRBS?.evaluateHidden()
        ProxyFormMKcpWBS?.evaluateHidden()
        ProxyFormMKcpHeader?.evaluateHidden()
    }
    
    func hidev2rayws() {
        let ProxyFormWSPath = self.form.rowBy(tag: kProxyFormWSPath) as? TextRow
        let ProxyFormWSHost = self.form.rowBy(tag: kProxyFormWSHost) as? TextRow
        ProxyFormWSPath?.hidden = true
        ProxyFormWSHost?.hidden = true
        ProxyFormWSPath?.evaluateHidden()
        ProxyFormWSHost?.evaluateHidden()
    }
    
    func hidev2rayhttp() {
        let ProxyFormHttpHost = self.form.rowBy(tag: kProxyFormHttpHost) as? TextRow
        let ProxyFormHttpPath = self.form.rowBy(tag: kProxyFormHttpPath) as? TextRow
        ProxyFormHttpHost?.hidden = true
        ProxyFormHttpPath?.hidden = true
        ProxyFormHttpHost?.evaluateHidden()
        ProxyFormHttpPath?.evaluateHidden()
    }
    
    func hidev2rayquic() {
        let ProxyFormQuicSecurity = self.form.rowBy(tag: kProxyFormQuicSecurity) as? PushRow<String>
        let ProxyFormQuicKey = self.form.rowBy(tag: kProxyFormQuicKey) as? PasswordRow
        let ProxyFormQuicHeader = self.form.rowBy(tag: kProxyFormQuicHeader) as? PushRow<String>
        ProxyFormQuicSecurity?.hidden = true
        ProxyFormQuicKey?.hidden = true
        ProxyFormQuicHeader?.hidden = true
        ProxyFormQuicSecurity?.evaluateHidden()
        ProxyFormQuicKey?.evaluateHidden()
        ProxyFormQuicHeader?.evaluateHidden()
    }
    
    func shareQRCode() {
        let _ = 123
    }
    
    func shareuri() {
        UIPasteboard.general.string = self.upstreamProxy.Uri()
        showTextHUD("Success".localized(), dismissAfterDelay: 1.5)
    }
    
    func deleteproxy() {
        let proxies = DBUtils.all(Proxy.self, sorted: "createAt").map({ $0 })
        for ep in proxies {
            if ep.host == self.upstreamProxy.host,
                ep.port == self.upstreamProxy.port {
                print ("Remove existing: " + self.upstreamProxy.name)
                self.navigationController?.popViewController(animated: true)
                try? DBUtils.softDelete(ep.uuid, type: Proxy.self)
            }
        }
    }
    
    @objc func save() {
        do {
            let values = form.values()
            guard let type = values[kProxyFormType] as? ProxyType else {
                throw ProxyConfigurationError.Error("You must choose a proxy type".localized())
            }
            guard let name = (values[kProxyFormName] as? String)?.trimmingCharacters(in: CharacterSet.whitespaces), !name.isEmpty else {
                throw ProxyConfigurationError.Error("Name can't be empty".localized())
            }
            if !self.isEdit {
                if let _ = defaultRealm.objects(Proxy.self).filter("name = '\(name)'").first {
                    throw ProxyConfigurationError.Error("Name already exists".localized())
                }
            }
            guard let host = (values[kProxyFormHost] as? String)?.trimmingCharacters(in: CharacterSet.whitespaces), !host.isEmpty else {
                throw ProxyConfigurationError.Error("Host can't be empty".localized())
            }
            guard let port = values[kProxyFormPort] as? Int else {
                throw ProxyConfigurationError.Error("Port can't be empty".localized())
            }
            guard port > 0 && port <= Int(UINT16_MAX) else {
                throw ProxyConfigurationError.Error("Invalid port".localized())
            }
            var authscheme: String?
            let user: String? = nil
            var password: String?
            switch type {
            case .Shadowsocks, .ShadowsocksR:
                guard let encryption = values[kProxyFormEncryption] as? String, !encryption.isEmpty else {
                    throw ProxyConfigurationError.Error("You must choose a encryption method".localized())
                }
                guard let pass = values[kProxyFormPassword] as? String, !pass.isEmpty else {
                    throw ProxyConfigurationError.Error("Password can't be empty".localized())
                }
                authscheme = encryption
                password = pass
            default:
                break
            }
            let ota = values[kProxyFormOta] as? Bool ?? false
            upstreamProxy.type = type // ss,ssr类型
            upstreamProxy.name = name // ss,ssr名称
            upstreamProxy.host = host // ss,ssr地址
            upstreamProxy.port = port // ss,ssr端口
            upstreamProxy.authscheme = authscheme // ss,ssr加密方式
            upstreamProxy.user = user
            upstreamProxy.password = password // ss,ssr密码
            upstreamProxy.ota = ota
            upstreamProxy.ssrProtocol = values[kProxyFormProtocol] as? String // ssr协议
            upstreamProxy.ssrProtocolParam = values[kProxyFormProtocolParam] as? String // ssr协议参数
            upstreamProxy.ssrObfs = values[kProxyFormObfs] as? String // ssr混淆
            upstreamProxy.ssrObfsParam = values[kProxyFormObfsParam] as? String // ssr混淆参数
            try DBUtils.add(upstreamProxy)
            close()
        }catch {
            showTextHUD("\(error)", dismissAfterDelay: 1.0)
        }
    }
    
}

