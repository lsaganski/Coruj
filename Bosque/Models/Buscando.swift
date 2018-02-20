//
//  Buscando.swift
//  Bosque
//
//  Created by Leonardo Saganski on 20/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import Foundation
import ObjectMapper

class Buscando: Mappable {

    var Distancia: Int = 0
    var Buscando: Bool = false
    var Cheguei: Bool = false
    var Entregue: Bool = false

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {

        Distancia <- map["Distancia"]
        Buscando <- map["Buscando"]
        Cheguei <- map["Cheguei"]
        Entregue <- map["Entregue"]
    }
}
