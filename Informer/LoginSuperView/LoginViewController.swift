//
//  LoginViewController.swift
//  Informer
//
//  Created by Hasan Sedaghat on 10/26/19.
//  Copyright © 2019 Hasan Sedaghat. All rights reserved.
//

import UIKit
import KVNProgress
protocol LoginPageDelegate {
    func goToNextStep()
    func goToPreviousStep()
}
class LoginViewController: UIViewController {
    
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var descLabelTopConst: NSLayoutConstraint!
    @IBOutlet var inputTXF: HSIndicatorTextfield!
    @IBOutlet var loginBTN: HSButton!
    @IBOutlet var inputTopConst: NSLayoutConstraint!
    @IBOutlet var loginTopConst: NSLayoutConstraint!
    
    var lastViewRect: CGFloat?
    var keyboardRect: CGFloat?
    var delegate:LoginPageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.tapToDismissKeyboard()
        self.inputTXF.addTarget(self, action: #selector(changeText(sender:)), for: .editingChanged)
        self.loginBTN.gradientColor(firstColor: #colorLiteral(red: 0.8078431373, green: 0.8078431373, blue: 0.8078431373, alpha: 1).cgColor, secondColor: #colorLiteral(red: 0.5490196078, green: 0.5529411765, blue: 0.5529411765, alpha: 1).cgColor)
        self.loginBTN.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.didSetConst()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.animateDescLabel()
            self.animateInputTXF()
            self.animateLoginBTN()
            self.handleKeyboard()
        }
    }
    
    func didSetConst() {
        self.descLabel.alpha = 0
        self.inputTXF.alpha = 0
        self.loginBTN.alpha = 0
    }
    
    @objc func changeText(sender:UITextField) {
        if sender.text != "" {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                if (self.loginBTN.layer.sublayers?.first is CAGradientLayer) {
                    let firstColor = #colorLiteral(red: 1, green: 0.7261096835, blue: 0, alpha: 1).cgColor
                    let secondColor = #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1).cgColor
                    (self.loginBTN.layer.sublayers?.first as! CAGradientLayer).colors = [firstColor,secondColor]
                    self.loginBTN.isValid = true
                }
            }, completion: nil)
        }
        else {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                if (self.loginBTN.layer.sublayers?.first is CAGradientLayer) {
                    let firstColor = #colorLiteral(red: 0.8078431373, green: 0.8078431373, blue: 0.8078431373, alpha: 1).cgColor
                    let secondColor = #colorLiteral(red: 0.5490196078, green: 0.5529411765, blue: 0.5529411765, alpha: 1).cgColor
                    (self.loginBTN.layer.sublayers?.first as! CAGradientLayer).colors = [firstColor,secondColor]
                    self.loginBTN.isValid = false
                }
            }, completion: nil)
        }
    }
    
    @IBAction func nextStep(_ sender: Any) {
        if loginBTN.isValid {
            KVNProgress.show()
            DataProvider.shared.user.mobileNumber = self.inputTXF.text!
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                KVNProgress.dismiss {
                    self.delegate?.goToNextStep()
                }
            }
        }
        else {
            KVNProgress.showError(withStatus: "Please Enter Your Email or PhoneNumber")
        }
    }
    
    func animateDescLabel() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.descLabel.alpha = 1
            self.descLabelTopConst.constant = self.descLabelTopConst.constant - 30
            self.view.layoutIfNeeded()
        })
    }
    
    func animateInputTXF() {
        UIView.animate(withDuration: 0.6, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.inputTXF.alpha = 1
            self.inputTopConst.constant = self.inputTopConst.constant - 30
            self.view.layoutIfNeeded()
        })
    }
    
    func animateLoginBTN() {
        UIView.animate(withDuration: 0.6, delay: 0.6, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.loginBTN.alpha = 1
            //self.loginTopConst.constant = self.loginTopConst.constant - 30
            self.view.layoutIfNeeded()
        })
    }
    
    func handleKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        lastViewRect = self.loginBTN.frame.origin.y + self.loginBTN.frame.size.height
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame:CGRect = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        self.keyboardRect = keyboardFrame.origin.y - keyboardFrame.size.height
        if self.lastViewRect! > keyboardRect! {
            let minus = self.lastViewRect! - keyboardRect!
            inputTopConst.constant = inputTopConst.constant - minus - 20
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if lastViewRect! > keyboardRect! {
            let minus = lastViewRect! - keyboardRect!
            inputTopConst.constant = inputTopConst.constant + minus + 20
            self.view.layoutIfNeeded()
        }
    }
    
}
