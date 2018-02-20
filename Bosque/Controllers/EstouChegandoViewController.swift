//
//  EstouChegandoViewController.swift
//  Bosque
//
//  Created by Leonardo Saganski on 27/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import UIKit
import Alamofire

class EstouChegandoViewController: BaseViewController, MenuDelegate, LocationControllerDelegate {

    @IBOutlet weak var btnChegando: UIButton!
    @IBOutlet weak var imgShadow: UIImageView!
    @IBOutlet weak var lblHint: UILabel!
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var imgDestination: UIImageView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var btnCancelarBusca: UIButton!
    @IBOutlet weak var btnCheguei: UIButton!
    @IBOutlet weak var btnEntregue: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        Menu.delegate = self
        LocationController.shared.delegate = self
    }

    @IBAction func clickChegando(_ sender: UIButton) {
        imgCar.isHidden = false
        imgDestination.isHidden = false
        progress.isHidden = false
        lblPercent.text = "0 %"
        lblPercent.isHidden = false
        lblDistance.text = ""
        lblDistance.isHidden = false
        btnCancelarBusca.isHidden = false

        btnChegando.isHidden = true
        imgShadow.isHidden = true
        lblHint.isHidden = true

        LocationController.shared.start()
    }

    func refreshUIFromLocation(msg: Int) {
        if msg == 101 {
            refreshProgress()
        } else if msg == 102 || msg == 103 {
            imgCar.isHidden = true
            imgDestination.isHidden = true
            progress.isHidden = true
            lblPercent.text = "0 %"
            lblPercent.isHidden = true
            btnCancelarBusca.isHidden = true
            btnCheguei.isHidden = true
            btnEntregue.isHidden = true
            lblDistance.text = msg == 102 ? "Busca cancelada" : "Entrega efetuada com sucesso."
            lblDistance.isHidden = false

            btnChegando.isHidden = false
            imgShadow.isHidden = false
            lblHint.isHidden = false

            perform(#selector(EstouChegandoViewController.clearMsg), with: nil, afterDelay: 5)
        }
    }

    func clearMsg() {
        lblDistance.text = ""
    }

    func refreshProgress() {
        self.progress.progress = Float(Globals.shared.percentReachedToDestination!)
        lblPercent.text = "\(Globals.shared.percentReachedToDestination!) %"
        lblDistance.text = "A \(Globals.shared.metersLeftToDestination!) metros da escola..."

        if Globals.shared.metersLeftToDestination! <= 100 {
            btnCheguei.isHidden = false
            btnEntregue.isHidden = false
        }

        if Globals.shared.metersLeftToDestination! <= Constants.LocationParams.MIN_DISTANCE_TO_SEND {
            sendBuscando()
        }

    }

    func sendBuscando() {
        let url = "\(Constants.Api.MAIN_PATH)\(Constants.Api.BUSCANDO_PATH)"

        var parameters = Parameters()
        parameters["CodigoAcesso"] = Globals.shared.loggedUser?.CodigoAcesso
        parameters["Distancia"] = Globals.shared.metersLeftToDestination

        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseObject(completionHandler: { (response: DataResponse<Buscando>) in
                switch(response.result) {
                case .success(let obj):
                    if response.result.value != nil {

                        if obj.Entregue == true {
                            LocationController.shared.stopAllLocations()
                            self.refreshUIFromLocation(msg: 103)
                        }
                    }

                    break

                case .failure(_):break}

                ToastView.findAndClose(fromView: self)
            })
    }

    func sendCheguei() {
        let url = "\(Constants.Api.MAIN_PATH)\(Constants.Api.CHEGUEI_PATH)"

        var parameters = Parameters()
        parameters["CodigoAcesso"] = Globals.shared.loggedUser?.CodigoAcesso

        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                switch(response.result) {
                case .success(let obj):
                    self.btnCheguei.isHidden = true
                    break
                case .failure(_):break
                }

                ToastView.findAndClose(fromView: self)
                self.btnCheguei.setTitleColor(.darkGray, for: .normal)
                self.btnCheguei.setTitle("Sua chegada foi informada", for: .normal)
                self.btnCheguei.isEnabled = false
            })
    }

    func sendEntregue() {
        let url = "\(Constants.Api.MAIN_PATH)\(Constants.Api.ENTREGUE_PATH)"

        var parameters = Parameters()
        parameters["CodigoAcesso"] = Globals.shared.loggedUser?.CodigoAcesso

        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                switch(response.result) {
                case .success(let obj):
                    if response.result.value != nil {
                        if String(describing: obj).contains("true") || String(describing: obj).contains("1") {
                            LocationController.shared.stopAllLocations()
                            self.refreshUIFromLocation(msg: 103)
                        }
                    }

                    break

                case .failure(_):break}

                ToastView.findAndClose(fromView: self)
            })
    }

    func sendCancelarBusca() {
        let url = "\(Constants.Api.MAIN_PATH)\(Constants.Api.CANCELAR_BUSCA_PATH)"

        var parameters = Parameters()
        parameters["CodigoAcesso"] = Globals.shared.loggedUser?.CodigoAcesso

        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                switch(response.result) {
                case .success(let obj):
                    if response.result.value != nil {
                        if String(describing: obj).contains("true") || String(describing: obj).contains("1") {
                            LocationController.shared.stopAllLocations()
                            self.refreshUIFromLocation(msg: 102)
                        }
                    }

                    break

                case .failure(_):break}

                ToastView.findAndClose(fromView: self)
            })
    }

    func click(button: Int) {
        switch button {
        case 0:
            let vc: CalendarioViewController = storyboard?.instantiateViewController(withIdentifier: "calendarioVC") as! CalendarioViewController
            self.present(vc, animated: true, completion: nil)
            break
        case 1:
            let vc: MensagensViewController = storyboard?.instantiateViewController(withIdentifier: "mensagensVC") as! MensagensViewController
            self.present(vc, animated: true, completion: nil)
            break
        case 2:
            let vc: SwayViewController = storyboard?.instantiateViewController(withIdentifier: "swayVC") as! SwayViewController
            self.present(vc, animated: true, completion: nil)
            break
        case 3:
            let vc: FormsViewController = storyboard?.instantiateViewController(withIdentifier: "formsVC") as! FormsViewController
            self.present(vc, animated: true, completion: nil)
            break
        case 4:
            let vc: EstouChegandoViewController = storyboard?.instantiateViewController(withIdentifier: "chegandoVC") as! EstouChegandoViewController
            self.present(vc, animated: true, completion: nil)
            break
        default:
            break
        }
    }

    @IBAction func clickCancelarBusca(_ sender: UIButton) {
        ToastView(createActivityIndicator: self).show()
        self.sendCancelarBusca()
    }

    @IBAction func clickCheguei(_ sender: UIButton) {
        ToastView(createActivityIndicator: self).show()
        self.sendCheguei()
    }

    @IBAction func btnEntregue(_ sender: UIButton) {
        ToastView(createActivityIndicator: self).show()
        self.sendEntregue()
    }
    
}
