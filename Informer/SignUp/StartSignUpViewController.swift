//
//  StartSignUpViewController.swift
//  Informer
//
//  Created by Hasan Sedaghat on 10/27/19.
//  Copyright © 2019 Hasan Sedaghat. All rights reserved.
//

import UIKit

class StartSignUpViewController: UIViewController {

    @IBOutlet var startBTN: HSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstColor = #colorLiteral(red: 1, green: 0.7261096835, blue: 0, alpha: 1).cgColor
        let secondColor = #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1).cgColor
        self.startBTN.gradientColor(firstColor: firstColor, secondColor:secondColor)
        self.startBTN.layer.cornerRadius = 10
    }
    
    @IBAction func start(_ sender: Any) {
        
    }
    
}
