//
//  SubscriptionListViewController.swift
//  ShadowCoel
//
//  Created by Coel on 2019/5/5.
//  Copyright © 2019 Coel Wu. All rights reserved.
//

import Foundation
import Cartography
import Eureka
import ShadowCoelModel

class SubscriptionListViewController: FormViewController {
    
    var subscribes: [Subscribe?] = []
    let allowNone: Bool
    let chooseCallback: ((Proxy?) -> Void)?
    
    init(allowNone: Bool = false, chooseCallback: ((Proxy?) -> Void)? = nil) {
        self.chooseCallback = chooseCallback
        self.allowNone = allowNone
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Subscribe".localized() // 导航栏标题
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add)) // 导航栏右侧按钮
        reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func add() {
        let vc = SubscriptionConfigurationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
     func reloadData() {
        subscribes = DBUtils.allNotDeleted(Subscribe.self, sorted: "createAt").map({ $0 })
        form.delegate = nil
        form.removeAll()
    }
    
}
