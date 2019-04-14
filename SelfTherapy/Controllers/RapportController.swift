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

    @IBOutlet var warningAnim: LOTAnimationView!
    @IBOutlet weak var anxCircle: UICircularProgressRing!
    @IBOutlet weak var stressCircle: UICircularProgressRing!
    @IBOutlet weak var depCircle: UICircularProgressRing!
    var options = UICircularGradientOptions(startPosition: .left, endPosition: .right, colors:  [UIColor.green ,UIColor.orange, UIColor.red], colorLocations: [0.1,0.5, 1.0])
    var anxiety = 0
    var stress = 0
    var depression = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupCirclesAnims()
        // Do any additional setup after loading the view.
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        depCircle.startProgress(to: CGFloat((depression*100) / 60) , duration: 5)
        stressCircle.startProgress(to: CGFloat((stress*100) / 60), duration: 5)
        anxCircle.startProgress(to: CGFloat((anxiety*100) / 60), duration: 5)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
