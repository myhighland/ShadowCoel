//
//  SubscriptionConfigurationViewController.swift
//  ShadowCoel
//
//  Created by Coel on 2019/5/27.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Foundation
import Eureka

public enum SubscriptionError: Error {
    case Error(String)
}

private let kSubscribeFormName = "name"
private let kSubscribeFormUrl = "url"

class SubscriptionConfigurationViewController: FormViewController {
    
    var upstreamSubscribe: Subscribe
    let isEdit: Bool
    
    override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init()
    }
    
    init(upstreamSubscribe: Subscribe? = nil) {
        if let subscribe = upstreamSubscribe {
            self.upstreamSubscribe = Subscribe(value: subscribe)
            self.isEdit = true
        }else {
            self.upstreamSubscribe = Subscribe()
            self.isEdit = false
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEdit {
            self.navigationItem.title = "Edit Subsciption".localized()
        }else {
            self.navigationItem.title = "Add Subsciption".localized()
        }
        generateForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
    }
    
    func generateForm() {
        form +++ Section()
            <<< TextRow(kSubscribeFormName) {
                $0.title = "Name".localized()
                $0.value = self.upstreamSubscribe.name
        }
            <<< TextRow(kSubscribeFormUrl) {
                $0.title = "URL".localized()
                $0.value = self.upstreamSubscribe.url
        }
    }
    
    @objc func save() {
        do {
            let values = form.values()
            guard let name = (values[kSubscribeFormName] as? String)?.trimmingCharacters(in: CharacterSet.whitespaces), !name.isEmpty else {
                throw SubscriptionError.Error("Name can not be empty".localized())
            }
            guard let url = (values[kSubscribeFormUrl] as? String)?.trimmingCharacters(in: CharacterSet.whitespaces), !url.isEmpty else {
                throw SubscriptionError.Error("Url can not be empty".localized())
            }
            upstreamSubscribe.name = name
            upstreamSubscribe.url = url
            // try DButils.add(upstreamSubscribe)
            close()
            } catch {
            showTextHUD("\(error)", dismissAfterDelay: 1.0)
        }
    }
}
