//
//  FirstViewController.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/12/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUserInfo()
    }

    func setupUserInfo () {
        if AuthService.instance.isLoggedIn {
            username.text = AuthService.instance.username
     
        }
        else {
            debugPrint(AuthService.instance.userEmail)
        }
    }
    @IBAction func logoutClicked(_ sender: Any) {
        AuthService.instance.logoutUser()
   
    }
}

