//
//  UrlSchemesViewController.swift
//  ShadowCoel
//
//  Created by Coel on 2019/5/4.
//  Copyright © 2019 Coel Wu. All rights reserved.
//

import UIKit
import Eureka

class UrlSchemesViewController: FormViewController {
    
    override func viewDidLoad() {
        navigationItem.title = "URL SCHEMES".localized()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        generateForm()
    }
    
    func generateForm(){
        form.delegate = nil
        form.removeAll()
        form +++ StartSchemes()
        form +++ StopSchemes()
        form +++ ToggleSchemes()
        form.delegate = self
        tableView?.reloadData()
    }
    
    func StartSchemes() -> Section {
        let section = Section("START VPN TUNNEL")
        section
            <<< LabelRow() {
                $0.title = "shadowcoel://connect"
        }
            <<< LabelRow() {
                $0.title = "shadowcoel://open"
        }
        return section
    }
    
    func StopSchemes() -> Section {
        let section = Section("STOP VPN TUNNEL")
        section
            <<< LabelRow() {
                $0.title = "shadowcoel://disconnect"
        }
            <<< LabelRow() {
                $0.title = "shadowcoel://close"
        }
        return section
    }
    
    func ToggleSchemes() -> Section {
        let section = Section("TOGGLE VPN TUNNEL")
        section
            <<< LabelRow() {
                $0.title = "shadowcoel://toggle"
        }
        return section
    }
    
}
