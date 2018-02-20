//
//  Recado.swift
//  Bosque
//
//  Created by Leonardo Saganski on 20/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import Foundation
import ObjectMapper

class Recado: Mappable {

    var Id: String = ""
    var ClienteId: String = ""
    var Categoria: String = ""
    var CriadoPor: String = ""
    var Titulo: String = ""
    var ImagemUrl: String = ""
    var RequerAutorizacao: String = ""
    var DataCriacao: String = ""
    var DataFormatada: String = ""
    var Corpo: String = ""
    var Visualizado: String = ""
    var Autorizado: String = ""

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        Id <- map["Id"]
        ClienteId <- map["ClienteId"]
        Categoria <- map["Categoria"]
        CriadoPor <- map["CriadoPor"]
        Titulo <- map["Titulo"]
        ImagemUrl <- map["ImagemUrl"]
        RequerAutorizacao <- map["RequerAutorizacao"]
        DataCriacao <- map["DataCriacao"]
        DataFormatada <- map["DataFormatada"]
        Corpo <- map["Corpo"]
        Visualizado <- map["Visualizado"]
        Autorizado <- map["Autorizado"]
    }
}
