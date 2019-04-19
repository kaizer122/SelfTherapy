//
//  RapportController.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/14/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit
import UICircularProgressRing
import Lottie

class RapportController: UIViewController {

    @IBOutlet weak var registerBtn: RoundedButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet var warningAnim: LOTAnimationView!
    @IBOutlet weak var anxCircle: UICircularProgressRing!
    @IBOutlet weak var stressCircle: UICircularProgressRing!
    @IBOutlet weak var depCircle: UICircularProgressRing!
    var options = UICircularGradientOptions(startPosition: .left, endPosition: .right, colors:  [UIColor.green ,UIColor.orange, UIColor.red], colorLocations: [0.1,0.5, 1.0])
    var anxiety = 0
    var stress = 0
    var depression = 0
    var mode : String = "all"
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupCirclesAnims()
        setupMode()
    }
    func setupCirclesAnims () {
        warningAnim.setAnimation(named: "warning")
        warningAnim.loopAnimation = true
        warningAnim.animationSpeed = 1
        warningAnim.play()
        depCircle.style = .gradient(options: options)
        depCircle.outerCapStyle = CGLineCap.round
        stressCircle.style = .gradient(options: options)
        stressCircle.outerCapStyle = CGLineCap.round
        anxCircle.style = .gradient(options: options)
        anxCircle.outerCapStyle = CGLineCap.round
    }
    func setupMode() {
        switch mode {
        case "Depression":
            anxCircle.isHidden = true
            stressCircle.isHidden = true
             backBtn.isHidden = false
            registerBtn.isHidden = true
            warningAnim.isHidden = true
        case "anxiete":
            depCircle.isHidden = true
            stressCircle.isHidden = true
             backBtn.isHidden = false
            registerBtn.isHidden = true
            warningAnim.isHidden = true
        case "stress":
            depCircle.isHidden = true
            anxCircle.isHidden = true
               backBtn.isHidden = false
            registerBtn.isHidden = true
            warningAnim.isHidden = true
        case "all":
            depCircle.isHidden = false
            anxCircle.isHidden = false
             stressCircle.isHidden = false
            backBtn.isHidden = true
            if (AuthService.instance.isLoggedIn){
                registerBtn.isHidden = true
                warningAnim.isHidden = true
            }
        default:
            
            return
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        depCircle.startProgress(to: CGFloat((depression*100) / 60) , duration: 5)
        stressCircle.startProgress(to: CGFloat((stress*100) / 60), duration: 5)
        anxCircle.startProgress(to: CGFloat((anxiety*100) / 60), duration: 5)
    }


}
