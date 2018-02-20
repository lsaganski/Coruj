//
//  CalendarioViewController.swift
//  Bosque
//
//  Created by Leonardo Saganski on 27/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import UIKit
import Alamofire

class CalendarioViewController: BaseViewController, MenuDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var list: [Listable] = []
    var headers: [String] = []
    var lastDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
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
    
    func loadData() {
        lastDate = ""
        list = []
        headers = []
        
        ToastView(createActivityIndicator: self).show()
        
        let url = "\(Constants.Api.MAIN_PATH)\(Constants.Api.CALENDARIO_PATH)"
        
        var parameters = Parameters()
        parameters["CodigoAcesso"] = Globals.shared.loggedUser?.CodigoAcesso
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseArray(completionHandler: { (response: DataResponse<[Calendario]>) in
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
                        //{
                        n = Listable()
                        n.date = self.lastDate
                        n.data = data
                        self.list.append(n)
                        
                        self.headers.append(self.lastDate)
                        //}
                        
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
        let obj: Calendario = self.list.filter {
            $0.date == header
            }[0].data[indexPath.row] as! Calendario
        
        let time = cell.viewWithTag(3) as! UILabel
        let text = cell.viewWithTag(5) as! VerticalAlignLabel
        
        let d: String = obj.DataFormatada
        let index = d.index(d.startIndex, offsetBy:10)
        
        time.text = "Postado às \(d.substring(from: index))"
        
        text.text = obj.Titulo
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }
    
}
