//
//  Calendario.swift
//  Bosque
//
//  Created by Leonardo Saganski on 20/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import Foundation
import ObjectMapper

class Calendario: Mappable {

    var Titulo: String = ""
    var Descricao: String = ""
    var DataCriacaoEvento: String = ""
    var DataInicio: String = ""
    var DataFormatada: String = ""
    var DataFim: String = ""

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        Titulo <- map["Titulo"]
        Descricao <- map["Descricao"]
        DataCriacaoEvento <- map["DataCriacaoEvento"]
        DataInicio <- map["DataInicio"]
        DataFormatada <- map["DataFormatada"]
        DataFim <- map["DataFim"]
    }
}
