//
//  Menu.swift
//  Bosque
//
//  Created by Leonardo Saganski on 25/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import UIKit

public protocol MenuDelegate {
    func click(button: Int)
}

@IBDesignable

class Menu: UIView {

    var contentView: UIView?
    public static var delegate: MenuDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        contentView = loadViewFromXib()
        
        // use bounds not frame or it'll be offset
        contentView!.frame = bounds
        
        // Make the view stretch with containing view
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view ( over any custom drawing > see note below )
        addSubview(contentView!)
    }
    
    func loadViewFromXib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func clickCalendario(_ sender: UIButton) {
        Menu.delegate?.click(button: 0)
    }
    
    @IBAction func clickMensagens(_ sender: UIButton) {
        Menu.delegate?.click(button: 1)
    }

    @IBAction func clickSway(_ sender: UIButton) {
        Menu.delegate?.click(button: 2)
    }
    
    @IBAction func clickForms(_ sender: UIButton) {
        Menu.delegate?.click(button: 3)
    }
    
    @IBAction func clickChegando(_ sender: UIButton) {
        Menu.delegate?.click(button: 4)
    }

}
