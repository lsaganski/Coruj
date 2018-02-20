//
//  Constants.swift
//  Bosque
//
//  Created by Leonardo Saganski on 16/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Colors {
        static let TABBAR_BACK_COLOR = "#555555"
        static let TABBAR_TEXT_COLOR = "#FFFFFF"
    }
    
    struct Values {
        static let SMS_NUMBER = "27368"
        static let SMS_MESSAGE = "bigbrain :"
    }
    
    struct Api {
        static let MAIN_PATH = "https://bigbraincorujinhaapi.azurewebsites.net/mobi/api/"
        static let SMS_PATH = "sms"
        static let CHECK_AUTH_PATH = "sms/token?key="
        static let LOGIN_PATH = "autenticacao"
        static let LOGIN_TOKEN_PATH = "autenticacao/token"
        static let CALENDARIO_PATH = "calendario/evento"
        static let ESCOLA_PATH = "buscar/todoscomunicados"
        static let PROFESSORES_PATH = "buscar/recados"
        static let SWAY_PATH = "buscar/todossway"
        static let FORMS_PATH = "buscar/todasenquetes"
        static let BUSCANDO_PATH = "proximidade/buscando"
        static let CHEGUEI_PATH = "proximidade/cheguei"
        static let ENTREGUE_PATH = "proximidade/entregue"
        static let CANCELAR_BUSCA_PATH = "proximidade/cancelarbusca"
    }
    
    struct DestinationLocation {
        // static let DESTINATION_LATITUDE = -23.628532  // Hot / It / Esc.
        // static let DESTINATION_LONGITUDE = -46.6639929 //   //
        static let DESTINATION_LATITUDE = Double((Globals.shared.loggedUser?.SedeLatidude)!)!
        static let DESTINATION_LONGITUDE = Double((Globals.shared.loggedUser?.SedeLongitude)!)!
    }
    
    struct LocationParams {
        static let DESIRED_ACCURACY = 200.0
        static let MIN_DISTANCE_TO_SEND = 2000
    }
}
