//
//  Globals.swift
//  Bosque
//
//  Created by Leonardo Saganski on 16/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import Foundation

class Globals {

    var loggedUser: User?
    var loggedGuid: String?
    
    //Singleton ----
    static let shared = Globals()
    private init() {}
    // -------------
    
    // Chegando
    public var percentReachedToDestination: Int?
    public var metersToDestination: Int?
    public var metersReachedToDestination: Int?
    public var metersLeftToDestination: Int?

}
