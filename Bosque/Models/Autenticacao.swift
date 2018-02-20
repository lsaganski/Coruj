//
//  Autenticacao.swift
//  Bosque
//
//  Created by Leonardo Saganski on 20/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import Foundation
import ObjectMapper

class Autenticacao: Mappable {

    var autenticado: Bool = false
    var usuario: User?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        autenticado <- map["Autenticado"]
        usuario <- map["usuario"]
    }
    
}
