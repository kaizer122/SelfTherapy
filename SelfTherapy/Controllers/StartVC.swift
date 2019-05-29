//
//  StartVC.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/19/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit
import TransitionableTab

class StartVC: UITabBarController {

      var showStat = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
}
    override func viewDidAppear(_ animated: Bool) {
        if showStat {
            let addmessageview = RapportPeriod(nibName: "RapportPer", bundle: nil)
            addmessageview.modalPresentationStyle = .overFullScreen
            addmessageview.modalTransitionStyle = .crossDissolve
            self.present(addmessageview, animated: true , completion: nil)
        }
    }
    
}
extension UITabBarController: TransitionableTab {
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
         return animateTransition(tabBarController, shouldSelect: viewController)
    }
}
