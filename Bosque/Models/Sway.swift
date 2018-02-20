//
//  Sway.swift
//  Bosque
//
//  Created by Leonardo Saganski on 20/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import Foundation
import ObjectMapper

class Sway: Mappable {

    var Id: String = ""
    var ClienteId: String = ""
    var Titulo: String = ""
    var LinkSway: String = ""
    var CriadoPor: String = ""
    var DataCriacao: String = ""
    var DataFormatada: String = ""
    var Visualizado: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        Id <- map["Id"]
        ClienteId <- map["ClienteId"]
        Titulo <- map["Titulo"]
        LinkSway <- map["LinkSway"]
        CriadoPor <- map["CriadoPor"]
        DataCriacao <- map["DataCriacao"]
        DataFormatada <- map["DataFormatada"]
        Visualizado <- map["Visualizado"]
    }
}
