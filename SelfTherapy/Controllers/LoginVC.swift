//
//  ViewController.swift
//  SmartInterphone
//
//  Created by Ladjemi Kais on 2/7/19.
//  Copyright © 2019 iof. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import Firebase


class LoginVC: UIViewController , GIDSignInUIDelegate {
  
    
    
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }


    @IBAction func SignInClicked(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = emailTxt.text , emailTxt.text != "" else {
            makeAlert(message: "invalid email")
            return }
        guard let pass = passwordTxt.text , passwordTxt.text != "" else {
            makeAlert(message: "invalid password")
            return }
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                print("Log in successful!")
                  self.updateLoginService()
              //  self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
        
      
    }
 
  
    func ForgotPassword(alert: UIAlertAction!) {
        print("forgot password cool")
    }
    
    func setupView () {
        // hide spinner
        spinner.isHidden = true
    }
 

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @IBAction func googlLoginClicked(_ sender: Any) {
        print("clicked google")
        GIDSignIn.sharedInstance()?.signIn()
    }
    @IBAction func fbLoginClicked(_ sender: Any) {
            let fbloginManager =  FBSDKLoginManager()
        
        fbloginManager.logIn(withReadPermissions: ["public_profile" , "email"],from: self) {
            (result, error) in
            if let error = error {
                debugPrint("could not login facebook", error)
            } else if result!.isCancelled {
                print("cancelled facebook login")
            } else {
                print (result!.token.tokenString!)
             let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        Auth.auth().currentUser?.linkAndRetrieveData(with: credential, completion: { (data, error) in
                            if let error = error  {
                             debugPrint(error.localizedDescription)
                                return
                            }
                    
                                self.updateLoginService()
                            
                        })
                        return
                    }
           
                    //logged in
                 self.updateLoginService()
                   
                   print("fb signed in")
                }
            }
            
        }
    }
    func updateLoginService(){
        AuthService.instance.userEmail = Auth.auth().currentUser!.email!
        AuthService.instance.username = Auth.auth().currentUser!.displayName!
       AuthService.instance.isLoggedIn = true
         performSegue(withIdentifier: LOGIN_TO_MENU , sender: self)
   
    }

    
    func makeAlert( message: String ) {
        let alert = UIAlertController(title: "Alert !", message: message, preferredStyle: .alert)
        let backButton = UIAlertAction (title: "Okay", style: .cancel, handler: nil)
        alert.addAction(backButton)
        self.present(alert,animated: true, completion: nil)
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
        
    }
    
    
	
}


