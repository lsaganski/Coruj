//
//  SmsViewController.swift
//  Bosque
//
//  Created by Leonardo Saganski on 18/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire

class SmsViewController: BaseViewController {
    
    @IBOutlet weak var pbProgress: UIProgressView!
    @IBOutlet weak var btnEnviar: UIButton!
    @IBOutlet weak var lblAguardando: UILabel!
    @IBOutlet weak var lblPercent: UILabel!

    var timer: Timer?
    var seconds = Float(1)
    let tick = Float(1) / Float(120)
    var progress = Float(0)
    
    var chegou = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func enviar(_ sender: UIButton) {
        sendSMS()
    }
    
    func sendSMS() {
        if (MFMessageComposeViewController.canSendText()) {
            let messageVC = MFMessageComposeViewController()
            Globals.shared.loggedGuid = UUID().uuidString
            messageVC.body = "\(Constants.Values.SMS_MESSAGE)\(Globals.shared.loggedGuid!)"
            messageVC.recipients = [Constants.Values.SMS_NUMBER]
            messageVC.messageComposeDelegate = self
            self.present(messageVC, animated: true, completion: nil)
        }
    }
    
    func smsCallback() {
        getAuthorization()
        
        btnEnviar.isHidden = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {
            timer in
            
            if self.seconds.truncatingRemainder(dividingBy: 20.0) == 0 && self.seconds < 100.0 {
                self.getAuthorization()
                self.checkAuthorization()
            }
            
            self.progress += self.tick
            self.pbProgress.setProgress(Float(self.progress), animated: true)
            self.lblPercent.text = "\(Int(self.seconds)) %"
            
            self.seconds += Float(1)
            
            if self.pbProgress.progress >= 1 || self.chegou == true {
                timer.invalidate()
                
                if self.chegou == true {
                    self.chegou = false
                    self.lblPercent.isHidden = true
                    self.lblAguardando.text = "Autenticando..."
                    self.goToMain()
                } else {
                    self.btnEnviar.isHidden = false
                    
                    let alert = UIAlertController(title: "Atenção", message: "Não foi possível autenticar por SMS. Vamos tentar utilizando seu usuário e senha.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                        self.performSegue(withIdentifier: "SmsToLogin", sender: nil)
                    })
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        })
    }
    
    func getAuthorization() {
        let url = "\(Constants.Api.MAIN_PATH)\(Constants.Api.SMS_PATH)"
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil {
                        print("Response : \(response.result.value)")
                        
                    }
                    break
                    
                case .failure(_):
                    print("Failure : \(response.result.error)")
                    
                    break
                }
            })
    }
    
    func checkAuthorization() {
        let url = "\(Constants.Api.MAIN_PATH)\(Constants.Api.CHECK_AUTH_PATH)\(Globals.shared.loggedGuid!)"
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil {
                        let token: String = response.result.value! as! String
                        print("Response : \(token)")
                        self.doLogin(token)
                    }
                    break
                    
                case .failure(_):
                    print("Failure : \(response.result.error)")
                    
                    break
                }
            })
    }
    
    func doLogin(_ token: String) {
        let url = "\(Constants.Api.MAIN_PATH)\(Constants.Api.LOGIN_TOKEN_PATH)?token=\(token)"
        Alamofire.request(url, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseObject(completionHandler: { (response: DataResponse<Autenticacao> ) in
                switch(response.result) {
                case .success(let obj):
                    if response.result.value != nil {
                        if obj.autenticado {
                            let user: User? = obj.usuario
                            
                            if user != nil {
                                Globals.shared.loggedUser = user
                                Identity.saveUserInfo(user!)
                                
                                print("Response : \(obj.usuario!.Nome)")
                                self.chegou = true
                            }
                        }
                    }
                    break
                    
                case .failure(_):
                    print("Failure : \(response.result.error)")
                    
                    break
                }
            })
    }
    
    func goToMain() {
        performSegue(withIdentifier: "SmsToMain", sender: nil)
    }
}

extension SmsViewController : MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller:      MFMessageComposeViewController, didFinishWith result: MessageComposeResult)  {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: { self.smsCallback() })
        default:
            break;
        }
    }
}
