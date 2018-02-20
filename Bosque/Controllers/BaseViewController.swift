//
//  BaseViewController.swift
//  Bosque
//
//  Created by Leonardo Saganski on 20/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func alert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            //...
        })
        self.present(alert, animated: true, completion: nil)
    }

}
