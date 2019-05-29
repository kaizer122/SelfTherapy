//
//  step.swift
//  PageControl
//
//  Created by mahdi on 5/1/19.
//  Copyright © 2019 Seemu. All rights reserved.
//

import UIKit
import CoreMotion


class StepsCounterVC: UIViewController {
    
    @IBOutlet weak var STEP: UILabel!
    @IBOutlet weak var image: UIImageView!
    var steps = 200
    
    @IBOutlet weak var text: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        steps = StatsService.instance.getCurrentSteps()
        text.text = "Have a walk of " + String(steps) + " steps!"
        image.alpha = 0.4
        PSEngine.shared.start()
        
        let dataUpdateTimer = Timer.scheduledTimer(withTimeInterval: PS.Constant.accelerometerUpdateInterval.rawValue,
                                                   repeats: true,
                                                   block: { _ in
                                                    self.STEP.text = String(PSEngine.shared.pedestrian.stepCount)
                                                    if  (PSEngine.shared.pedestrian.stepCount >= self.steps) {
                                                        NotificationCenter.default.post(name: .didCompleteStep, object: nil)

                                                    }
                                                    
        })
        
        dataUpdateTimer.fire()
    }
}
