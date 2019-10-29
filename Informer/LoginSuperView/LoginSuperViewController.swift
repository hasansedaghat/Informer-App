//
//  LoginViewController.swift
//  Informer
//
//  Created by Hasan Sedaghat on 10/21/19.
//  Copyright © 2019 Hasan Sedaghat. All rights reserved.
//

import UIKit

class LoginSuperViewController: UIViewController,LoginPageDelegate{
    
    @IBOutlet var logo: UIImageView!
    @IBOutlet var logoHeightConst: NSLayoutConstraint!
    @IBOutlet var logoVerticalConst: NSLayoutConstraint!
    @IBOutlet var effectView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.didSetConst()
        self.view.tapToDismissKeyboard()
        (self.children.first as! LoginViewController).delegate = self
        (self.children.last as! VerificationViewController).delegate = self
        (self.children.last)?.view.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.didSetConst()
        startAnimation()
    }
    
    func goToNextStep() {
        UIView.animate(withDuration: 0.4 , delay: 0, options: .curveEaseInOut, animations: {
            self.scrollView.setContentOffset(CGPoint.init(x: self.view.frame.width, y: 0), animated: false)
            (self.children.first)?.view.alpha = 0
            (self.children.last)?.view.alpha = 1
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        (self.children.last as! VerificationViewController).startTimer()
    }
    
    func goToPreviousStep() {
        UIView.animate(withDuration: 0.4 , delay: 0, options: .curveEaseInOut, animations: {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
            (self.children.first)?.view.alpha = 1
            (self.children.last)?.view.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func didSetConst() {
        self.logoVerticalConst.constant = 0
        self.logoHeightConst.constant = 56
    }
    
    func startAnimation() {
        let multiplie = (812 / self.view.frame.height)
        let const = (300 / multiplie)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.effectView.backgroundColor = #colorLiteral(red: 0, green: 0.1960784314, blue: 0.2784313725, alpha: 0.2)
            self.logoVerticalConst.constant = -(const)
            self.logoHeightConst.constant = 36
            self.view.layoutIfNeeded()
        })
    }
    
    
}
