//
//  LoginViewController.swift
//  Bosque
//
//  Created by Leonardo Saganski on 18/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class LoginViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtUsername.delegate = self
        txtPassword.delegate = self
    }
    
    @IBAction func enter(_ sender: UIButton?) {
        
        let err = self.validate()
        
        if err.characters.count <= 0 {
            
            ToastView(createActivityIndicator: self).show()
            
            tryLogin()
            
        } else {
            self.alert(title: "Atenção", msg: err)
        }
    }
    
    func validate() -> String {
        var err = ""
        
        if (txtUsername.text?.characters.count)! <= 0 ||
            (txtPassword.text?.characters.count)! <= 0 {
            err += "Preencha todos os campos."
        }
        
        return err
    }
    
    func tryLogin() {
        let url = "\(Constants.Api.MAIN_PATH)\(Constants.Api.LOGIN_PATH)?telefone=\(txtUsername.text!)&cpf=\(txtPassword.text!)&idDevice=11111"
        Alamofire.request(url, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseObject(completionHandler: { (response: DataResponse<Autenticacao>) in
                switch(response.result) {
                case .success(let obj):
                    ToastView.findAndClose(fromView: self)
                    if response.result.value != nil {
                        if obj.autenticado {
                            self.doLogin(obj: obj)
                        } else {
                            self.alert(title: "Atenção", msg: "Usuário ou senha inválidos. Tente novamente.")
                        }
                    } else {
                        self.alert(title: "Atenção", msg: "Não foi possível validar o acesso. Tente novamente.")
                    }
                    
                    break
                    
                case .failure(_):
                    ToastView.findAndClose(fromView: self)
                    self.alert(title: "Atenção", msg: "Não foi possível validar o acesso. Tente novamente.")
                    break
                }
            })
    
    }
    
    func doLogin(obj: Autenticacao) {
        let user: User? = obj.usuario
        
        if user != nil {
            Globals.shared.loggedUser = user
            Identity.saveUserInfo(user!)
            
            self.performSegue(withIdentifier: "LoginToMain", sender: nil)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if textField.tag == 1 {
            txtPassword.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            self.enter(nil)
        }
        // Do not add a line break
        return false
    }
}
