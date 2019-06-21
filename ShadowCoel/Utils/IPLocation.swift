//
//  IPLocation.swift
//  ShadowCoel
//
//  Created by Coel on 2019/6/14.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import MMDB_Swift

class IPLocation {
    
    open func IP2CountryCode(IP: String) -> String? {
        
        var countrycode:String? = ""
        
        guard let db = MMDB() else {
            DDLogError("Failed to open DB.")
            return ""
        }
        
        if let country = db.lookup(IP) {
            countrycode = country.isoCode
        }
        
        if countrycode == "" {
            countrycode = "WW"
        }
        
        return countrycode
    }
    
}
