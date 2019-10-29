//
//  PersonalInfoViewController.swift
//  Informer
//
//  Created by Hasan Sedaghat on 10/27/19.
//  Copyright © 2019 Hasan Sedaghat. All rights reserved.
//

import UIKit
import KVNProgress
class PersonalInfoViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var firstStepLabel: UILabel!
    @IBOutlet var secondStepLabel: UILabel!
    @IBOutlet var firstStepView: UIView!
    @IBOutlet var nextBTN: HSButton!
    @IBOutlet var selectProfileIMG: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var fullNameTXF: HSIndicatorTextfield!
    @IBOutlet var emailTXF: HSIndicatorTextfield!
    @IBOutlet var mobileTXF: HSIndicatorTextfield!
    @IBOutlet var passwordTXF: HSIndicatorTextfield!
    
    private let firstColor = #colorLiteral(red: 1, green: 0.7261096835, blue: 0, alpha: 1).cgColor
    private let secondColor = #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1).cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstStepView.layer.cornerRadius = firstStepView.frame.width / 2
        secondStepLabel.layer.cornerRadius = firstStepLabel.layer.cornerRadius
        secondStepLabel.setBorder(color: #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1), width: 3)
        self.firstStepView.gradientColor(firstColor: firstColor, secondColor:secondColor)
        
        self.nextBTN.gradientColor(firstColor: #colorLiteral(red: 0.8078431373, green: 0.8078431373, blue: 0.8078431373, alpha: 1).cgColor, secondColor: #colorLiteral(red: 0.5490196078, green: 0.5529411765, blue: 0.5529411765, alpha: 1).cgColor)
        self.nextBTN.layer.cornerRadius = 10
        
        self.selectProfileIMG.layer.cornerRadius = self.selectProfileIMG.frame.width / 2
        self.selectProfileIMG.setBorder(color: #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1), width: 3)
        
        self.view.tapToDismissKeyboard()
        self.scrollView.handleKeyboard()
        
        self.fullNameTXF.delegate = self
        self.emailTXF.delegate = self
        self.passwordTXF.delegate = self
        
        self.fullNameTXF.addTarget(self, action: #selector(changeText(sender:)), for: .editingChanged)
        self.emailTXF.addTarget(self, action: #selector(changeText(sender:)), for: .editingChanged)
        self.passwordTXF.addTarget(self, action: #selector(changeText(sender:)), for: .editingChanged)
        
        self.mobileTXF.text = DataProvider.shared.user.mobileNumber
    }
    
    @objc func changeText(sender:UITextField) {
        if fullNameTXF.text != "" {
            if emailTXF.text != "" {
                if passwordTXF.text != "" {
                    UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                        if (self.nextBTN.layer.sublayers?.first is CAGradientLayer) {
                            let firstColor = #colorLiteral(red: 1, green: 0.7261096835, blue: 0, alpha: 1).cgColor
                            let secondColor = #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1).cgColor
                            (self.nextBTN.layer.sublayers?.first as! CAGradientLayer).colors = [firstColor,secondColor]
                            self.nextBTN.isValid = true
                        }
                    }, completion: nil)
                }
                else {
                    UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                        if (self.nextBTN.layer.sublayers?.first is CAGradientLayer) {
                            let firstColor = #colorLiteral(red: 0.8078431373, green: 0.8078431373, blue: 0.8078431373, alpha: 1).cgColor
                            let secondColor = #colorLiteral(red: 0.5490196078, green: 0.5529411765, blue: 0.5529411765, alpha: 1).cgColor
                            (self.nextBTN.layer.sublayers?.first as! CAGradientLayer).colors = [firstColor,secondColor]
                            self.nextBTN.isValid = false
                        }
                    }, completion: nil)
                }
            }
            else {
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    if (self.nextBTN.layer.sublayers?.first is CAGradientLayer) {
                        let firstColor = #colorLiteral(red: 1, green: 0.7261096835, blue: 0, alpha: 1).cgColor
                        let secondColor = #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1).cgColor
                        (self.nextBTN.layer.sublayers?.first as! CAGradientLayer).colors = [firstColor,secondColor]
                        self.nextBTN.isValid = true
                    }
                }, completion: nil)
            }
        }
        else {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                if (self.nextBTN.layer.sublayers?.first is CAGradientLayer) {
                    let firstColor = #colorLiteral(red: 0.8078431373, green: 0.8078431373, blue: 0.8078431373, alpha: 1).cgColor
                    let secondColor = #colorLiteral(red: 0.5490196078, green: 0.5529411765, blue: 0.5529411765, alpha: 1).cgColor
                    (self.nextBTN.layer.sublayers?.first as! CAGradientLayer).colors = [firstColor,secondColor]
                    self.nextBTN.isValid = false
                }
            }, completion: nil)
        }
    }
    
    @IBAction func next(_ sender: Any) {
        if nextBTN.isValid {
            KVNProgress.showSuccess(withStatus: "Well Done! \n Your Account is Created")
        }
        else {
            KVNProgress.showError(withStatus: "Please Fill All Fields")
        }
    }
    
}
