//
//  EndVC.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 5/10/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit
import Lottie

class EndVC: UIViewController {

    @IBOutlet weak var welcomeAnim: LOTAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        welcomeAnim.setAnimation(named: "success")
        welcomeAnim.animationSpeed = 1
        welcomeAnim.play()
        NotificationCenter.default.post(name: .didCompleteStep, object: nil)
    }

}
