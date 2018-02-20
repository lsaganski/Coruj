//
//  OneSignalResult.swift
//  Bosque
//
//  Created by Leonardo Saganski on 20/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import Foundation
import ObjectMapper

class OneSignalResult: Mappable {

    var Success: Bool = false
    var Id: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        Success <- map["Success"]
        Id <- map["Id"]
    }
}
