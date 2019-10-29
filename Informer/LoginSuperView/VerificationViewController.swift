//
//  VerificationViewController.swift
//  Informer
//
//  Created by Hasan Sedaghat on 10/26/19.
//  Copyright © 2019 Hasan Sedaghat. All rights reserved.
//

import UIKit
import KVNProgress
class VerificationViewController: UIViewController {

    @IBOutlet var oneTimeCodeTXF: HSIndicatorTextfield!
    @IBOutlet var submitBTN: HSButton!
    @IBOutlet var timerLabel: UILabel!
    
    var delegate : LoginPageDelegate?
    var timeTimer: Timer?
    var activeSecond = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oneTimeCodeTXF.addTarget(self, action: #selector(changeText(sender:)), for: .editingChanged)
        self.submitBTN.gradientColor(firstColor: #colorLiteral(red: 0.8078431373, green: 0.8078431373, blue: 0.8078431373, alpha: 1).cgColor, secondColor: #colorLiteral(red: 0.5490196078, green: 0.5529411765, blue: 0.5529411765, alpha: 1).cgColor)
        self.submitBTN.layer.cornerRadius = 10
        timerLabel.text = "(" + String(format:"%02d",self.activeSecond.secondsToHoursMinutesSeconds().1) + " : " + String(format:"%02d",self.activeSecond.secondsToHoursMinutesSeconds().2) + ")"
    }
    
    @objc func fireTimer() {
        if activeSecond >= 1 {
            self.activeSecond -= 1
            timerLabel.text = "(" + String(format:"%02d",self.activeSecond.secondsToHoursMinutesSeconds().1) + " : " + String(format:"%02d",self.activeSecond.secondsToHoursMinutesSeconds().2) + ")"
        }
        else {
            
        }
    }
    
    func startTimer() {
        activeSecond = 120
        timeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc func changeText(sender:UITextField) {
        if sender.text != "" {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                if (self.submitBTN.layer.sublayers?.first is CAGradientLayer) {
                    let firstColor = #colorLiteral(red: 1, green: 0.7261096835, blue: 0, alpha: 1).cgColor
                    let secondColor = #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1).cgColor
                    (self.submitBTN.layer.sublayers?.first as! CAGradientLayer).colors = [firstColor,secondColor]
                    self.submitBTN.isValid = true
                }
            }, completion: nil)
        }
        else {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                if (self.submitBTN.layer.sublayers?.first is CAGradientLayer) {
                    let firstColor = #colorLiteral(red: 0.8078431373, green: 0.8078431373, blue: 0.8078431373, alpha: 1).cgColor
                    let secondColor = #colorLiteral(red: 0.5490196078, green: 0.5529411765, blue: 0.5529411765, alpha: 1).cgColor
                    (self.submitBTN.layer.sublayers?.first as! CAGradientLayer).colors = [firstColor,secondColor]
                    self.submitBTN.isValid = false
                }
            }, completion: nil)
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        if submitBTN.isValid {
            self.parent?.performSegue(withIdentifier: "goToStartup", sender: nil)
        }
        else {
            KVNProgress.showError(withStatus: "Please Enter Verification Code")
        }
    }
    
    @IBAction func changeNumber(_ sender: Any) {
        timeTimer?.invalidate()
        delegate?.goToPreviousStep()
    }
    
}
