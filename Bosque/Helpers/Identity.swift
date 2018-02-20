//
//  Identity.swift
//  Bosque
//
//  Created by Leonardo Saganski on 17/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import Foundation
import UIKit

class Identity: NSObject {

    static func saveUserInfo(_ user: User) {
    
        let defaults = UserDefaults.standard
        
        defaults.set(user.Nome, forKey: "BIGBRAIN_NAME")
        defaults.set(user.Email, forKey: "BIGBRAIN_EMAIL")
        defaults.set(user.CodigoAcesso, forKey: "BIGBRAIN_TOKEN")
        defaults.synchronize()
        
    }
    
    static func getUserInfo() -> User {
        
        let defaults = UserDefaults.standard
        
        var user: User = User()
        
        user.Nome = defaults.string(forKey: "BIGBRAIN_NAME")!
        user.Email = defaults.string(forKey: "BIGBRAIN_EMAIL")!
        user.CodigoAcesso = defaults.string(forKey: "BIGBRAIN_TOKEN")!
 
        return user
    }
    
    static func deleteUserInfo() {
    
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: "BIGBRAIN_NAME")
        defaults.removeObject(forKey: "BIGBRAIN_EMAIL")
        defaults.removeObject(forKey: "BIGBRAIN_TOKEN")
        defaults.synchronize()
        
    }
    
    static func getUserName() -> String! {
    
        let defaults = UserDefaults.standard
        
        return defaults.string(forKey: "BIGBRAIN_NAME")
    
    }
    
    static func isLogged() -> Bool {
    
        guard let _: String? = getUserName() else {
            return false
        }
        
        Globals.shared.loggedUser = getUserInfo()
        
        return true
        
    }
    
}
