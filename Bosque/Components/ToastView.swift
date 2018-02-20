//
//  ToastView.swift
//  LibertyAuto
//
//  Created by Fabio Araujo Bruscato on 03/10/16.
//  Copyright © 2016 CEABS Servicos S/A. All rights reserved.
//

import UIKit

enum ToastPosition: Int {
    case top = 0
    case center = 1
    case bottom = 2
}

class ToastView: NSObject {
    static let TIME = 0.2;
    static let VIEW_TAG: Int! = 951357
    
    private let BORDER_SIZE: CGFloat! = 10.0;
    private let CORNER_RADIUS: CGFloat! = 5.0;
    private let ALPHA: CGFloat! = 0.8;
    private let SHADOW_OPACITY: Float! = 0.7;
    private let SHADOW_RADIUS: CGFloat! = 6.0;
    private let SHADOW_OFFSET = CGSize(width: 3.0, height: 3.0);
    private let DEF_TIMEOUT = 2.0;
    
    private var viewController: UIViewController!
    private var parentView: UIView!;
    private var viewToast: UIView!;
    private var text: String!;
    private var timeOutOn: Bool = true;
    private var onComplete: (() -> Void)!;
    private var onTimeOut: (() -> Void)!;
    private var timeOut: TimeInterval!;
    
    private var timer: Timer!;
    
    override init() {
        self.viewController = nil
        self.parentView = nil;
        self.viewToast = nil;
        self.text = nil;
        self.onComplete = nil;
        self.onTimeOut = nil;
    }
    
    /**
     Cria o toast com indicador de atividade
     */
    convenience init(createActivityIndicator parentView: UIViewController, timeOutOn: Bool = false, onComplete: (() -> Void)! = nil) {
        self.init();
        self.viewController = parentView
        if let view = parentView.tabBarController?.selectedViewController?.view {
            self.parentView = view
        }
        else {
            self.parentView = parentView.view
        }
        self.text = nil;
        self.timeOut = DEF_TIMEOUT;
        self.timeOutOn = timeOutOn;
        self.onComplete = onComplete;
    }
    
    /**
     Cria o toast com indicador de atividade e com o timeOut informado
     */
    convenience init(createActivityIndicator parentView: UIViewController, timeOut: TimeInterval!, onComplete: (() -> Void)! = nil, onTimeOut: (() -> Void)! = nil) {
        self.init();
        self.viewController = parentView
        if let view = parentView.tabBarController?.selectedViewController?.view {
            self.parentView = view
        }
        else {
            self.parentView = parentView.view
        }
        self.text = nil;
        self.timeOut = timeOut;
        self.timeOutOn = true;
        self.onComplete = onComplete;
        self.onTimeOut = onTimeOut;
    }
    
    /**
     Cria o toast com o texto informado
     */
    convenience init(parentView: UIViewController, text: String!, timeOutOn: Bool = true, onComplete: (() -> Void)! = nil) {
        self.init();
        self.viewController = parentView
        if let view = parentView.tabBarController?.selectedViewController?.view {
            self.parentView = view
        }
        else {
            self.parentView = parentView.view
        }
        self.text = text;
        self.timeOut = DEF_TIMEOUT;
        self.timeOutOn = timeOutOn;
        self.onComplete = onComplete;
    }
    
    /**
     Cria o toast com o texto e o timeOut informados
     */
    convenience init(parentView: UIViewController, text: String!, timeOut: TimeInterval!, onComplete: (() -> Void)! = nil, onTimeOut: (() -> Void)! = nil) {
        self.init();
        self.viewController = parentView
        if let view = parentView.tabBarController?.selectedViewController?.view {
            self.parentView = view
        }
        else {
            self.parentView = parentView.view
        }
        //self.parentView = (parentView.tabBarController?.selectedViewController?.view)!
        self.text = text;
        self.timeOutOn = true;
        self.timeOut = timeOut;
        self.onComplete = onComplete;
        self.onTimeOut = onTimeOut;
    }
    
    /// Exibe o toast
    ///
    /// - parameter position: Posição (opicional), padrao centro
    func show(position: ToastPosition = ToastPosition.center, onShow: (() -> Void)! = nil) {
        //Teste de exibicao de "Toast"
        let frame = self.parentView.bounds;
        
        ToastView.findAndClose(fromView: self.viewController, animated: false)
        
        // Configura o indicador de atividade
        if (text == nil || text.isEmpty) {
            let progress: UIActivityIndicatorView! = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge);
            progress.startAnimating();
            progress.sizeToFit();
            progress.frame = CGRect(x: BORDER_SIZE, y: BORDER_SIZE, width: progress.bounds.width, height: progress.bounds.height);
            
            // Configura a view de fundo
            switch position {
            case .bottom:
                viewToast = UIView(frame: CGRect(x: frame.midX - ((progress.bounds.width / 2) + BORDER_SIZE), y: ((frame.midY * 1.7) - BORDER_SIZE), width: progress.bounds.width + (BORDER_SIZE * 2), height: progress.bounds.height + (BORDER_SIZE * 2)));
                break
            case .top:
                viewToast = UIView(frame: CGRect(x: frame.midX - ((progress.bounds.width / 2) + BORDER_SIZE), y: ((frame.midY * 0.3) + BORDER_SIZE), width: progress.bounds.width + (BORDER_SIZE * 2), height: progress.bounds.height + (BORDER_SIZE * 2)));
                break
            default:
                viewToast = UIView(frame: CGRect(x: frame.midX - ((progress.bounds.width / 2) + BORDER_SIZE), y: (frame.midY - ((progress.bounds.height + BORDER_SIZE) / 2)), width: progress.bounds.width + (BORDER_SIZE * 2), height: progress.bounds.height + (BORDER_SIZE * 2)));
                break
            }
            
            viewToast.backgroundColor = UIColor.black;
            viewToast.layer.cornerRadius = CORNER_RADIUS;
            viewToast.alpha = 0.0;
            viewToast.layer.shadowColor = UIColor.black.cgColor;
            viewToast.layer.shadowOpacity = SHADOW_OPACITY;
            viewToast.layer.shadowRadius = SHADOW_RADIUS;
            viewToast.layer.shadowOffset = SHADOW_OFFSET;
            viewToast.addSubview(progress);
        }
        else {
            // Configura o Label
            let label: UILabel! = UILabel();
            label.numberOfLines = 3;
            label.text = text;
//            label.font = UIFont(name: Constants.Fonts.BOLD, size: 15)
            label.textColor = UIColor.white;
            label.textAlignment = .center
            label.sizeToFit();
            
            // Verifica se o tamanho final do label excedeu o do pai
            if ((label.bounds.width + (BORDER_SIZE * 2.8)) >= parentView.bounds.width) {
                let newBounds = CGRect(x: 0, y: 0, width: (parentView.bounds.width - (BORDER_SIZE * 2.8)), height: (label.bounds.height * 2))
                label.bounds = newBounds
            }
            
            // Atualiza o layout do label
            label.sizeToFit()
            label.frame = CGRect(x: BORDER_SIZE, y: BORDER_SIZE, width: label.bounds.width, height: label.bounds.height);
            
            // Configura a view de fundo
            switch position {
            case .bottom:
                viewToast = UIView(frame: CGRect(x: frame.midX - ((label.bounds.width / 2) + BORDER_SIZE),  y: ((frame.midY * 1.7) + BORDER_SIZE), width: label.bounds.width + (BORDER_SIZE * 2), height: label.bounds.height + (BORDER_SIZE * 2)));
                break
            case .top:
                viewToast = UIView(frame: CGRect(x: frame.midX - ((label.bounds.width / 2) + BORDER_SIZE),  y: ((frame.midY * 0.3) + BORDER_SIZE), width: label.bounds.width + (BORDER_SIZE * 2), height: label.bounds.height + (BORDER_SIZE * 2)));
                break
            default:
                viewToast = UIView(frame: CGRect(x: frame.midX - ((label.bounds.width / 2) + BORDER_SIZE),  y: (frame.midY - ((label.bounds.height + BORDER_SIZE) / 2)), width: label.bounds.width + (BORDER_SIZE * 2), height: label.bounds.height + (BORDER_SIZE * 2)));
                break
            }
            viewToast.backgroundColor = UIColor.black;
            viewToast.layer.cornerRadius = CORNER_RADIUS;
            viewToast.alpha = 0.0;
            viewToast.layer.shadowColor = UIColor.black.cgColor;
            viewToast.layer.shadowOpacity = SHADOW_OPACITY;
            viewToast.layer.shadowRadius = SHADOW_RADIUS;
            viewToast.layer.shadowOffset = SHADOW_OFFSET;
            viewToast.addSubview(label);
        }
        
        viewToast.tag = ToastView.VIEW_TAG
        
        // Exibe a view
        UIView.animate(withDuration: ToastView.TIME, delay: 0.0, options:([UIViewAnimationOptions.curveEaseOut, UIViewAnimationOptions.allowUserInteraction]),
                       animations: {
                        self.viewToast.alpha = self.ALPHA;
        }, completion: {
            (value: Bool) in
            self.parentView.addSubview(self.viewToast);
            
            if (self.timeOutOn) {
                self.timer = Timer.scheduledTimer(timeInterval: self.timeOut, target: self, selector: #selector(ToastView.closeTimeOut), userInfo: nil, repeats: false);
            }
            
            if onShow != nil {
                onShow()
            }
        }
        );
    }
    
    func closeTimeOut() {
        // Remove a view do toast
        UIView.animate(withDuration: ToastView.TIME, delay: 0.0, options: ([UIViewAnimationOptions.curveEaseIn, UIViewAnimationOptions.beginFromCurrentState]),
                       animations: {
                        self.viewToast.alpha = 0.0
        }, completion: {
            (value: Bool) in
            self.viewToast.removeFromSuperview();
            // Bloco executado ao fechar
            if (self.onComplete != nil) {
                self.onComplete();
            }
            
            // Bloco executado no timeOut
            if (self.onTimeOut != nil) {
                self.onTimeOut();
            }
        }
        );
    }
    
    /// Fecha o toast e executa o bloco (opcional) informado
    ///
    /// - parameter onCloseComplete: Bloco a ser executado apos fechar o toast
    func close(onCloseComplete: (() -> Void)! = nil) {
        self.onTimeOut = nil;
        if (self.timer != nil) {
            self.timer.invalidate();
            self.timer = nil;
        }
        
        // Remove a view do toast
        if (viewToast != nil) {
            UIView.animate(withDuration: ToastView.TIME, delay: 0.0, options: ([UIViewAnimationOptions.curveEaseIn, UIViewAnimationOptions.beginFromCurrentState]),
                           animations: {
                            self.viewToast.alpha = 0.0
            }, completion: {
                (value: Bool) in
                self.viewToast.removeFromSuperview();
                if (self.onComplete != nil) {
                    self.onComplete();
                    self.onComplete = nil;
                }
                if (onCloseComplete != nil) {
                    onCloseComplete();
                }
            }
            );
        }
    }
    
    /// Procura uma view do toast na view informada e a remove
    ///
    /// - parameter fromView:        View pai
    /// - parameter animated:        Animar remocao da view (opcional)
    /// - parameter onCloseComplete: Bloco chamado apos remover a view (opcional)
    ///
    /// - returns: Resposta indicando se a view foi encontrada
    @discardableResult
    static func findAndClose(fromView: UIViewController, animated: Bool! = true, onCloseComplete: (() -> Void)! = nil) -> Bool {
        var viewToRemove: UIView
        if let view = fromView.tabBarController?.selectedViewController?.view {
            viewToRemove = view
        }
        else {
            viewToRemove = fromView.view
        }
        
        if let viewToast = viewToRemove.viewWithTag(ToastView.VIEW_TAG) {
            // Remove a view do toast
            if (!animated) {
                viewToast.removeFromSuperview()
                if (onCloseComplete != nil) {
                    onCloseComplete()
                }
            }
            else {
                UIView.animate(withDuration: ToastView.TIME, delay: 0.0, options: ([UIViewAnimationOptions.curveEaseIn, UIViewAnimationOptions.beginFromCurrentState]),
                               animations: {
                                viewToast.alpha = 0.0
                }, completion: {
                    (value: Bool) in
                    viewToast.removeFromSuperview()
                    
                    if (onCloseComplete != nil) {
                        onCloseComplete()
                    }
                }
                )
            }
            return true
        }
        
        return false
    }
}
