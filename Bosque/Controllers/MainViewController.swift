//
//  MainViewController.swift
//  Bosque
//
//  Created by Leonardo Saganski on 21/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {
    
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblNome.text = Globals.shared.loggedUser?.Nome
        lblEmail.text = Globals.shared.loggedUser?.Email
    }

    @IBAction func clickSair(_ sender: UIButton) {
        Globals.shared.loggedGuid = nil
        Globals.shared.loggedUser = nil
        Identity.deleteUserInfo()
        
        performSegue(withIdentifier: "MainToSms", sender: nil)
    }
    
    
}
