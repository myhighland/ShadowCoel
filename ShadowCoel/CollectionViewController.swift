//
//  CollectionViewController.swift
//  Potatso
//
//  Created by LEI on 5/31/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import Foundation
import Cartography

private let rowHeight: CGFloat = 135

class CollectionViewController: SegmentPageVC {

    let pageVCs = [
        ProxyRuleSetListViewController(),
        ProxyListViewController(),
        SubscriptionListViewController(),
        CloudViewController(),
    ]

    override func pageViewControllersForSegmentPageVC() -> [UIViewController] {
        return pageVCs
    }

    override func segmentsForSegmentPageVC() -> [String] {
        return ["Rule Set".localized(), "Proxy".localized(), "Subscribe".localized(), "Cloud Set".localized()]
    }

    override func showPage(_ index: Int) {
        if index < 3 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        }else {
            navigationItem.rightBarButtonItem = nil
        }
        super.showPage(index)
    }
    
    lazy var titleButton: UIButton = {
        let b = UIButton(type: .custom)
        b.setTitleColor(UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), for: UIControlState())
        b.addTarget(self, action: #selector(HomeVC.handleTitleButtonPressed), for: .touchUpInside)
        if let titleLabel = b.titleLabel {
            titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
        }
        return b
    }()

    @objc func add() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let vc = ProxyRuleSetConfigurationViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let alert = UIAlertController(title: "Add Proxy".localized(), message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Import From QRCode".localized(), style: .default, handler: { (action) in
                let importer = Importer(vc: self)
                importer.importConfigFromQRCode()
            }))
            alert.addAction(UIAlertAction(title: "Import From URL".localized(), style: .default, handler: { (action) in
                let importer = Importer(vc: self)
                importer.importConfigFromUrl()
            }))
            alert.addAction(UIAlertAction(title: "Manual Settings".localized(), style: .default, handler: { (action) in
                let vc = ProxyConfigurationViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil))
            if let presenter = alert.popoverPresentationController {
                if let rightBtn : View = navigationItem.rightBarButtonItem?.value(forKey: "view") as? View {
                    presenter.sourceView = rightBtn
                    presenter.sourceRect = rightBtn.bounds
                } else {
                    presenter.sourceView = titleButton
                    presenter.sourceRect = titleButton.bounds
                }
            }
            self.present(alert, animated: true, completion: nil)
            // 单一方法
            // let vc = ProxyConfigurationViewController()
            // navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = SubscriptionConfigurationViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}

