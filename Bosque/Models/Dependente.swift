//
//  Dependente.swift
//  Bosque
//
//  Created by Leonardo Saganski on 20/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import Foundation
import ObjectMapper

class Dependente: Mappable {
    
    var Id: String = ""
    var Nome: String = ""
    var Email: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        Id <- map["Id"]
        Nome <- map["Nome"]
        Email <- map["Email"]
    }
}
