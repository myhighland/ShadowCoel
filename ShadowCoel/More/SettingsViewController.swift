//
//  SettingsViewController.swift
//  ShadowCoel
//
//  Created by Coel on 2019/4/25.
//  Copyright © 2019 Coel Wu. All rights reserved.
//

import UIKit
import Eureka
import Foundation
import Appirater
import ICSMainFramework
import MessageUI
import SafariServices
import LocalAuthentication
import ShadowCoelLibrary

private let kAuth = "auth"

enum FeedBackType: String, CustomStringConvertible {
    case Email = "Email"
    case Forum = "Forum"
    case None = ""
    
    var description: String {
        return rawValue.localized()
    }
}

class SettingsViewController: FormViewController, MFMailComposeViewControllerDelegate, SFSafariViewControllerDelegate {
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        generateForm()
    }
    
    func generateForm() {
        form.delegate = nil
        form.removeAll()
        form +++ generateTunnelSection()
        form +++ generateAdvanceSection()
        form +++ generateHelpSection()
        form.delegate = self
        tableView?.reloadData()
    }
    
    func generateAdvanceSection() -> Section {
        let section = Section("ADVANCE")
        section
            <<< ActionRow() {
                $0.title = "Siri".localized()
            }
            <<< ActionRow() {
                $0.title = "Sync".localized()
                $0.value = SyncManager.shared.currentSyncServiceType.rawValue
                }.onCellSelection({ [unowned self] (cell, row) -> () in
                    SyncManager.shared.showSyncVC(inVC: self)
                })
            <<< ActionRow() {
                $0.title = self.isTouchIDOrFaceID().localized()
                $0.hidden = Condition.function([kAuth]) { form in
                    if let support = Optional.some(self.isTouchIDOrFaceID()) {
                        return support == "None"
                    }
                }
            }
            <<< ActionRow() {
                $0.title = "Hide VPN Icon".localized()
            }
            <<< ActionRow() {
                $0.title = "Reset".localized()
            }
        return section
        }
    
    
    func generateHelpSection() -> Section {
        let section = Section("HELP")
        section
            <<< ActionRow {
                $0.title = "User Manual".localized()
                }.onCellSelection({ [unowned self] (cell, row) in
                    self.showUserManual()
                })
            <<< ActionRow() {
                $0.title = "About".localized()
                }.cellSetup({ (cell, row) -> () in
                    cell.accessoryType = .disclosureIndicator
                    cell.selectionStyle = .default
                }).onCellSelection({ [unowned self](cell, row) -> () in
                    cell.setSelected(false, animated: true)
                    self.showAbout()
                })
        return section
    }
    
    func generateTunnelSection() -> Section {
        let section = Section("TUNNEL")
        section
            <<< ActionRow() {
                $0.title = "Proxy"
            }
            <<< ActionRow() {
                $0.title = "DNS"
            }
            <<< ActionRow() {
                $0.title = "UDP"
            }
        return section
        }
    
    func showUserManual() {
        let url = "https://manual.potatso.com/"
        let vc = BaseSafariViewController(url: URL(string: url)!, entersReaderIfAvailable: false)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

    func showAbout() {
        let vc = AboutViewController()
        navigationController?.pushViewController(vc,animated: true)
    }
    
    // 判断是否为Touch ID或者Face ID,返回结果
    func isTouchIDOrFaceID() -> String {
        let context = LAContext()
        if #available(iOS 11.0, *) {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                if context.biometryType == LABiometryType.touchID {
                    return String("Touch ID")
                } else if context.biometryType == LABiometryType.faceID {
                    return String("Face ID")
                } else {
                    return String("None")
                }
            }
        } else {
            return String("None")
            // Fallback on earlier versions
        }
        return String("None")
    }
    
    @objc func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}
