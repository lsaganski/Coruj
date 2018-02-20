//
//  WebViewController.swift
//  Bosque
//
//  Created by Leonardo Saganski on 31/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import UIKit
import Foundation

class WebViewController: UIViewController, MenuDelegate, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var navigation: UINavigationBar!
    
    var mytitle: String = ""
    var link: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ToastView(createActivityIndicator: self).show()
        
        navigation.topItem?.title = self.mytitle
        title = mytitle
        
        let url = URL(string: self.link)
        
        let request = URLRequest(url: url!)
        self.webView.delegate = self
        self.webView.loadRequest(request)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) {
//            (data, response, error) in
//
//            if error == nil {
//                self.webView.loadRequest(request)
//            }
//        }
        
//        task.resume()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        ToastView.findAndClose(fromView: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Menu.delegate = self
    }

    @IBAction func btnBackClick(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
}
