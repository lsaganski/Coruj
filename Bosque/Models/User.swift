//
//  User.swift
//  Bosque
//
//  Created by Leonardo Saganski on 20/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {

    var Id: String = ""
    var Nome: String = ""
    var Cpf: String = ""
    var Email: String = ""
    var CodigoAcesso: String = ""
    var TipoResponsavel: String = ""
    var IdDevice: String = ""
    var Telefone: String = ""
    var SedeLatidude: String = "0"
    var SedeLongitude: String = "0"
    var UltimoAcesso: String = ""
    var Dependentes: [Dependente]?

    required init?(map: Map) {
        
    }
    
    init() {}
    
    func mapping(map: Map) {
        Id <- map["Id"]
        Nome <- map["Nome"]
        Cpf <- map["Cpf"]
        Email <- map["Email"]
        CodigoAcesso <- map["CodigoAcesso"]
        TipoResponsavel <- map["TipoResponsavel"]
        IdDevice <- map["IdDevice"]
        Telefone <- map["Telefone"]
        SedeLatidude <- map["SedeLatidude"]
        SedeLongitude <- map["SedeLongitude"]
        UltimoAcesso <- map["UltimoAcesso"]
        Dependentes <- map["Dependentes"]
    }
}
