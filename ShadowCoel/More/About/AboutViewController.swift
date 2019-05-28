//
//  AboutViewController.swift
//  ShadowCoel
//
//  Created by Coel on 2019/5/4.
//  Copyright © 2019 Coel Wu. All rights reserved.
//

import UIKit
import Eureka
import ICSMainFramework
import AcknowList

class AboutViewController: FormViewController {
    
    override func viewDidLoad() {
        navigationItem.title = "About".localized() // 设置标题为About,并本地化
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        generateForm()
    }
    
    func generateForm() {
        form.delegate = nil
        form.removeAll()
        form +++ GenerateLogoForm()
        form +++ GenerateVersionForm()
        form +++ GenerateContatForm()
        form +++ GenerateUrlSchemes()
        form +++ GernerateAcknowledgements()
        form.delegate = self
        tableView?.reloadData()
    }
    
    // 生成图标
    func GenerateLogoForm() -> Section{
        let section = Section(){
            $0.header = HeaderFooterView<ShadowCoelLogoView>(.class)
        }
        return section
    }
    
    // 显示版本
    func GenerateVersionForm() -> Section{
        let section = Section()
        section
            <<< LabelRow(){
                $0.title = "Version".localized()
                $0.value = AppEnv.fullVersion
        }
        return section
    }
    
    func GenerateContatForm() -> Section {
        let section = Section()
        section
            <<< ActionRow() {
                $0.title = "Rate on App Store".localized()
                $0.value = "@ShadowCoel"
                }.onCellSelection({ [unowned self] (cell, row) -> () in
                    self.followTwitter()
                }).cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "App Store")
                }
            <<< ActionRow(){
                $0.title = "Follow on Twitter".localized()
                $0.value = "@ShadowCoel"
                }.onCellSelection({ [unowned self] (cell, row) -> () in
                    self.followTwitter()
                }).cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "Twitter")
                }
            <<< ActionRow(){
                $0.title = "Follow on Github".localized()
                $0.value = "@TheWanderingCoel"
                }.onCellSelection({ [unowned self] (cell, row) -> () in
                    self.folllowGithub()
                }).cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "Github")
                }
            <<< ActionRow(){
                $0.title = "Get Source Code".localized()
                $0.value = "@ShadowCoel"
                }.onCellSelection({ [unowned self] (cell, row) -> () in
                    self.GetSourceCode()
                }).cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "Git")
                }
            <<< ActionRow(){
                $0.title = "Join Telegram Group".localized()
                $0.value = "@ShadowCoel"
                }.onCellSelection({ [unowned self] (cell, row) -> () in
                    self.JoinTelegramGroup()
                }).cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "Telegram")
                }
        return section
    }
    
    func GenerateUrlSchemes() -> Section {
        let section = Section("URL SCHEMES")
        section
            <<< ActionRow() {
                $0.title = "URL Schemes"
                }.onCellSelection({ [unowned self] (cell, row) -> () in
                    self.ShowUrlSchemes()
                })
        return section
    }
    
    func GernerateAcknowledgements() -> Section {
        let section = Section("ACKNOWLEDGEMENTS".localized())
        section
            <<< ActionRow() {
                $0.title = "ShadowCoel"
                }.onCellSelection({ [unowned self] (cell, row) -> () in
                    self.ShowShadowCoelAcknowledgements()
                })
            <<< ActionRow() {
                $0.title = "PacketTunnel"
                }.onCellSelection({ [unowned self] (cell, row) -> () in
                    self.ShowPacketTunnelAcknowledgements()
                })
            <<< ActionRow() {
                $0.title = "TodayWidget"
                }.onCellSelection({ [unowned self] (cell, row) -> () in
                    self.ShowTodayWidgetAcknowledgements()
                })
        return section
    }
    
    func followTwitter() {
        UIApplication.shared.openURL(URL(string: "https://twitter.com/intent/user?screen_name=potatsoapp")!)
        }
    
    func folllowGithub() {
        UIApplication.shared.openURL(URL(string: "https://github.com/TheWanderingCoel")!)
    }
    
    func GetSourceCode() {
        UIApplication.shared.openURL(URL(string: "https://github.com/shadowcoel/ShadowCoel")!)
    }
    
    func JoinTelegramGroup() {
        UIApplication.shared.openURL(URL(string: "https://t.me/joinchat/NEvfCxR69vGzvUna-Bdzrg")!)
    }
    
    func ShowUrlSchemes() {
        let vc = UrlSchemesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ShowShadowCoelAcknowledgements() {
        let vc = AcknowListViewController(fileNamed: "Pods-ShadowCoel-acknowledgements")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ShowPacketTunnelAcknowledgements() {
        let vc = AcknowListViewController(fileNamed: "Pods-PacketTunnel-acknowledgements")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ShowTodayWidgetAcknowledgements() {
        let vc = AcknowListViewController(fileNamed: "Pods-TodayWidget-acknowledgements")
        navigationController?.pushViewController(vc, animated: true)
    }

}

// ShadowCoel图标类
class ShadowCoelLogoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.frame = CGRect(x: 0, y: 19, width: 60, height: 60) // y代表垂直距离
        imageView.autoresizingMask = .flexibleWidth
        self.frame = CGRect(x: 0, y: 19, width: 60, height: 60) // 两处大小必须相同
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
