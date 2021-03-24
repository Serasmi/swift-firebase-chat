//
//  ViewController.swift
//  swift-firebase-chat
//
//  Created by Сергей Смирнов on 23.03.2021.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor(named: "AppCyan")?.cgColor
    }


}

