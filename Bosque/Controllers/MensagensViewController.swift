//
//  MensagensViewController.swift
//  Bosque
//
//  Created by Leonardo Saganski on 27/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import UIKit
import Alamofire

class MensagensViewController: BaseViewController, MenuDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var list: [Listable] = []
    var headers: [String] = []
    var lastDate: String = ""
    var selected: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 220;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Menu.delegate = self
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
    
    @IBAction func clickEscola(_ sender: UIButton) {
        self.selected = 0
        loadData()
    }
    
    @IBAction func clickProfessores(_ sender: UIButton) {
        self.selected = 1
        loadData()
    }
    
    func loadData() {
        lastDate = ""
        list = []
        headers = []
        
        ToastView(createActivityIndicator: self).show()
        
        let url = "\(Constants.Api.MAIN_PATH)\(self.selected == 0 ? Constants.Api.ESCOLA_PATH : Constants.Api.PROFESSORES_PATH)"
        
        var parameters = Parameters()
        parameters["CodigoAcesso"] = Globals.shared.loggedUser?.CodigoAcesso
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseArray(completionHandler: { (response: DataResponse<[Comunicado]>) in
                switch(response.result) {
                case .success(let obj):
                    ToastView.findAndClose(fromView: self)
                    if response.result.value != nil {
                        
                        var n: Listable = Listable()
                        var data: [Any] = []
                        for o in obj {
                            let d: String = o.DataFormatada
                            let index = d.index(d.startIndex, offsetBy:10)
                            
                            if d.substring(to: index) != self.lastDate {
                                if data.count > 0 {
                                    n = Listable()
                                    n.date = self.lastDate
                                    n.data = data
                                    self.list.append(n)
                                    
                                    self.headers.append(self.lastDate)
                                }
                                
                                self.lastDate = d.substring(to: index)
                                data = []
                            }
                            
                            data.append(o)
                        }
                        
                        //após terminar, faz mais uma vez para os últimos da lista
                        n = Listable()
                        n.date = self.lastDate
                        n.data = data
                        self.list.append(n)
                        
                        self.headers.append(self.lastDate)

                        self.tableView.reloadData()
                    }
                    
                    break
                    
                case .failure(_):
                    ToastView.findAndClose(fromView: self)
                    break
                }
            })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let header: String = self.headers[section]
        let sections = self.list.filter {
            $0.date == header
        }[0].data.count
        
        return sections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellContent", for: indexPath)
        
        let header: String = self.headers[indexPath.section]
        let obj: Comunicado = self.list.filter {
                $0.date == header
            }[0].data[indexPath.row] as! Comunicado
        
        let bar = cell.viewWithTag(1)!
        let icon = cell.viewWithTag(2) as! UIImageView
        let time = cell.viewWithTag(3) as! UILabel
        let cat = cell.viewWithTag(4) as! UILabel
        let text = cell.viewWithTag(5) as! UILabel
        let check = cell.viewWithTag(6) as! UIImageView
        let novo = cell.viewWithTag(7) as! UIImageView
        let textDetail = cell.viewWithTag(55) as! UILabel
        
        bar.backgroundColor = self.selected == 0 ? UIColor(hexString: "ABA401") : UIColor(hexString: "013E65")
        icon.image = self.selected == 0 ? #imageLiteral(resourceName: "crj_ic_escola") : #imageLiteral(resourceName: "crj_ic_professores")
        
        let d: String = obj.DataFormatada
        let index = d.index(d.startIndex, offsetBy:10)
        
        time.text = "Postado às \(d.substring(from: index))"
        
        cat.isHidden = self.selected != 0
        cat.text = obj.Categoria
        
        text.text = obj.Titulo
        textDetail.text = obj.Corpo
        
        if indexPath.row == 0 {
            obj.Visualizado = "true"
        }
        
        check.image = obj.Visualizado == "true" ? #imageLiteral(resourceName: "crj_ic_done") : #imageLiteral(resourceName: "crj_ic_not_done")
        novo.isHidden = obj.Visualizado == "true"
        novo.image = self.selected == 0 ? #imageLiteral(resourceName: "crj_ic_novo_yellow") : #imageLiteral(resourceName: "crj_ic_novo_blue")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellHeader") 
        
        let header: String = self.headers[section]
        
        let date = cell?.viewWithTag(1) as! UILabel
        
        date.text = header
        date.layer.cornerRadius = 20.0
        date.clipsToBounds = true
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.selected == 0 {
            let header: String = self.headers[indexPath.section]
            let obj: Comunicado = self.list.filter {
                $0.date == header
                }[0].data[indexPath.row] as! Comunicado
            
            let vc: WebViewController = storyboard?.instantiateViewController(withIdentifier: "webVC") as! WebViewController
            vc.link = obj.UrlMensagem
            vc.mytitle = "Mensagens"
            
            self.present(vc, animated: true, completion: nil)

        }
    }
}
