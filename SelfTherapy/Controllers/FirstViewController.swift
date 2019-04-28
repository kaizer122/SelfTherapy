//
//  FirstViewController.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/12/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit
import Lottie
import Firebase

class FirstViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var welcomeAnim: LOTAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUserInfo()
        setupAnim()
    }
    func setupAnim (){
        welcomeAnim.setAnimation(named: "success")
        welcomeAnim.animationSpeed = 1
        welcomeAnim.play()
    }
    func setupUserInfo () {
        if AuthService.instance.isLoggedIn {
            username.text = "Welcome "+AuthService.instance.username + " !"
           
        }
        else {
            debugPrint(AuthService.instance.userEmail)
        }
    }
    @IBAction func logoutClicked(_ sender: Any) {
        AuthService.instance.logoutUser()
   
    }
}

