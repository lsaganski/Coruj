//
//  Formulario.swift
//  Bosque
//
//  Created by Leonardo Saganski on 20/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import Foundation
import ObjectMapper

class Formulario: Mappable {

    var Id: String = ""
    var ClienteId: String = ""
    var Titulo: String = ""
    var EnqueteForms: String = ""
    var DataCriacao: String = ""
    var DataFormatada: String = ""
    var Status: String = ""
    var CriadoPor: String = ""
    var Visualizado: String = ""

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        Id <- map["Id"]
        ClienteId <- map["ClienteId"]
        Titulo <- map["Titulo"]
        EnqueteForms <- map["EnqueteForms"]
        DataCriacao <- map["DataCriacao"]
        DataFormatada <- map["DataFormatada"]
        Status <- map["Status"]
        CriadoPor <- map["CriadoPor"]
        Visualizado <- map["Visualizado"]
    }
}
