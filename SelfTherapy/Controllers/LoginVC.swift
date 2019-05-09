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
import TransitionButton

class LoginVC: UIViewController , GIDSignInUIDelegate {
  
    
    
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var signinBtn: TransitionButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }


    
    @IBAction func SignInClicked(_ sender: Any) {
  
        signinBtn.startAnimation()
        
        guard let email = emailTxt.text , emailTxt.text!.contains("@") && emailTxt.text!.contains(".") else {
            makeAlert(message: "invalid email")
            signinBtn.stopAnimation()
            return }
        guard let pass = passwordTxt.text , checkPass(text: pass)  else {
            makeAlert(message: "password is weak , your password needs at least 6 characters")
              signinBtn.stopAnimation()
            return }
       
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
             if let error = error {
            if let errCode = AuthErrorCode(rawValue: error._code) {
                
                self.handleAuthErrors(errCode, error , email: email , pass: pass)
                }
            }else {
                
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
                 self.signinBtn.startAnimation()
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
        signinBtn.stopAnimation(animationStyle: .expand, completion: {
              self.performSegue(withIdentifier: LOGIN_TO_MENU , sender: self)
        })

   
    }

    
    func makeAlert( message: String ) {
        signinBtn.stopAnimation(animationStyle: .shake, completion: {
            let alert = UIAlertController(title: "Alert !", message: message, preferredStyle: .alert)
            let backButton = UIAlertAction (title: "Okay", style: .cancel, handler: nil)
            
            alert.addAction(backButton)
            self.present(alert,animated: true, completion: nil)
        })
    }
    
    fileprivate func registerUser(email: String , pass: String) {
        let alert = UIAlertController(title: "Finish Registration", message: "Please choose a nickname then retype your password to complete your registration.", preferredStyle: .alert)
        let backButton = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
        let confirmButton = UIAlertAction (title: "Create account", style: .default, handler: { (action: UIAlertAction!) in
            guard let nickname = alert.textFields![0].text , nickname != "" else {
                self.makeAlert(message: "invalid nickname")
                
                return }
            if (alert.textFields![1].text == pass) {
                Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                    if let error = error {
                        if let errCode = AuthErrorCode(rawValue: error._code) {
                            self.handleAuthErrors(errCode, error , email: email , pass: pass)
                        }
                    }
                    else {
                        let changeRequest =  Auth.auth().currentUser!.createProfileChangeRequest()
                        changeRequest.displayName = nickname
                        changeRequest.commitChanges(completion: { (error) in
                            if error != nil {
                                self.makeAlert(message: "Error while assigning new nickname !")
                                
                            } else {
                                Auth.auth().currentUser?.reload(completion: { (error) in
                                    if error != nil {
                                        self.makeAlert(message: "Error while reloading your data !")
                                        self.spinner.isHidden = true
                                        self.spinner.stopAnimating()
                                    } else {
                                        self.updateLoginService()
                                    }
                                })
                            }
                        })
                        
                        
                    }
                })
            } else {
            
                self.makeAlert(message: "Passwords don't match!")
            }
        })
        alert.addTextField(configurationHandler: { (nickname) in
            nickname.placeholder = "Your nickname"
        
        })
        alert.addTextField(configurationHandler: { (passwordrep) in
            passwordrep.placeholder = "Repeat passowrd"
            passwordrep.isSecureTextEntry = true
        })
        alert.addAction(backButton)
        alert.addAction(confirmButton)
        self.present(alert,animated: true, completion: nil)
        
    }
    
    fileprivate func handleAuthErrors(_ errCode: AuthErrorCode, _ error: Error? , email: String , pass: String) {
        switch errCode {
        case .weakPassword:
         self.makeAlert(message: "Weak Password !")
           
        case .networkError:
            self.makeAlert(message: "Network error, please verify your connetion!")
         
        case .userNotFound:
            self.registerUser(email: email , pass: pass)
        case .emailAlreadyInUse:
            self.makeAlert(message: "This email is already in use!")
           
        case .invalidEmail:
            self.makeAlert(message: "This email is invalid !")
         
        case .wrongPassword:
            self.makeAlert(message: "Wrong Password!")
        
        default:
            self.makeAlert(message: "Authentication failed , sorry!")
     
        }
    }
    func checkPass(text : String) -> Bool{
        
        var res : Bool = false
        res = text.count > 5 ? true : false
        
        return res
        
    }
    
	
}


