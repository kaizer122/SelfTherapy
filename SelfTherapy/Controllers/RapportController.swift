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
    @IBOutlet weak var depLbl: UILabel!
    @IBOutlet weak var axLbl: UILabel!
    @IBOutlet weak var stressLbl: UILabel!
    let options = UICircularRingGradientOptions(startPosition: .left, endPosition: .right, colors:  [UIColor.green ,UIColor.orange, UIColor.red], colorLocations: [0.1,0.5, 1.0])
    var anxiety = 0
    var stress = 0
    var depression = 0
    var showStat = false
    var mode : String = "all"
   public  var showBtn : Bool = false
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
       depLbl.superview?.bringSubviewToFront(depLbl)
        axLbl.superview?.bringSubviewToFront(axLbl)
        stressLbl.superview?.bringSubviewToFront(stressLbl)
        setupCirclesAnims()
        setupMode()
      
        }
    
    @IBAction func backClicked(_ sender: Any) {
        performSegue(withIdentifier: "showStart", sender: nil)
    }
    
  
    
    func setupCirclesAnims () {
        warningAnim.setAnimation(named: "nuage")
        warningAnim.loopAnimation = true
        warningAnim.animationSpeed = 1
        warningAnim.play()
        depCircle.gradientOptions = options
        depCircle.outerCapStyle = CGLineCap.round
        stressCircle.gradientOptions = options
        stressCircle.outerCapStyle = CGLineCap.round
        anxCircle.gradientOptions = options
        anxCircle.outerCapStyle = CGLineCap.round
    }
    func setupMode() {
        switch mode {
        case "Depression":
            anxCircle.isHidden = true
            axLbl.isHidden = true
            stressLbl.isHidden = true
            stressCircle.isHidden = true
             backBtn.isHidden = false
            registerBtn.isHidden = true
            warningAnim.isHidden = true
        case "anxiete":
            depLbl.isHidden = true
            stressLbl.isHidden = true
            depCircle.isHidden = true
            stressCircle.isHidden = true
             backBtn.isHidden = false
            registerBtn.isHidden = true
            warningAnim.isHidden = true
        case "stress":
            axLbl.isHidden = true
            depLbl.isHidden = true
            depCircle.isHidden = true
            anxCircle.isHidden = true
               backBtn.isHidden = false
            registerBtn.isHidden = true
            warningAnim.isHidden = true
        case "all":
            backBtn.isHidden  = showBtn ? false : true
            depCircle.isHidden = false
            anxCircle.isHidden = false
             stressCircle.isHidden = false
            axLbl.isHidden = false
            depLbl.isHidden = false
             stressLbl.isHidden = false
            
            if (AuthService.instance.isLoggedIn){
                registerBtn.isHidden = true
                warningAnim.isHidden = true
            }
        default:
            
            return
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        depCircle.startProgress(to: CGFloat((depression*10) / 6) , duration: 2)
        stressCircle.startProgress(to: CGFloat((stress*10) / 6), duration: 2)
        anxCircle.startProgress(to: CGFloat((anxiety*10) / 6), duration: 2)
    }

    @IBAction func registerClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "rapportToLogin", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rapportToLogin" {
            let viewController:LoginVC = segue.destination as! LoginVC
            viewController.stress = stress
            viewController.depression = depression
            viewController.anxiety = anxiety
        }
        if segue.identifier == "showStart" {
            let viewController:StartVC = segue.destination as! StartVC
            viewController.showStat = showStat ? true : false
        }
    }
}
