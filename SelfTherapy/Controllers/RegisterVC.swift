//
//  RegisterVCViewController.swift
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

class RegisterVC: UIViewController ,GIDSignInUIDelegate {

//outlets
    @IBOutlet weak var famNameTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repPasswordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        GIDSignIn.sharedInstance()?.uiDelegate = self
        setupView()
    }


    
    @IBAction func facebookSignupClicked(_ sender: Any) {
        
        let fbloginManager =  FBSDKLoginManager()
        
        fbloginManager.logIn(withReadPermissions: ["public_profile" , "email"],from: self) {
            (result, error) in
            if let error = error {
                debugPrint("could not login facebook", error)
            } else if result!.isCancelled {
                print("cancelled facebook login")
            } else {
                print("login success")
         
            }
            
        }
    }
   
    @IBAction func registerOnClick(_ sender: Any) {
        
           spinner.isHidden = false
            spinner.startAnimating()
        guard let username = usernameTxt.text , usernameTxt.text != "" else {
            makeAlert(message: "invalid username")
            return
        }
        guard let email = emailTxt.text , emailTxt.text != "" else {
            makeAlert(message: "invalid email")
            return
        }
        guard let passwd = passwordTxt.text , passwordTxt.text != "" else {
            makeAlert(message: "invalid password")
            return
        }
        guard let repPasswd = repPasswordTxt.text , repPasswordTxt.text != "" else {
            makeAlert(message: "invalid repeated password")
            return
        }
        
        guard let name = nameTxt.text , nameTxt.text != "" else {
            makeAlert(message: "invalid name")
            return
        }
        guard let famName = famNameTxt.text , famNameTxt.text != "" else {
            makeAlert(message: "invalid family name")
            return
        }
        let isEqual = (passwd == repPasswd)
        if !isEqual {
            makeAlert(message: "passwords do not match")
            return
        }
        
      registerUser(email: email, password: passwd , username: username)
    }
    
    func registerUser (email: String , password : String  , username : String ) {
           print ("sign in entered")

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print(error!)
            } else {
                print("Registration Successful!")
  
                
                //self.performSegue(withIdentifier: REGISTER_TO_MENU, sender: self)
            }
        }
    }
    @IBAction func googleBtnClicked(_ sender: Any) {
        print("clicked google")
       // spinner.isHidden = false
      //  spinner.startAnimating()
        GIDSignIn.sharedInstance()?.signIn()
    }

    func setupView () {
        // hide spinner
        spinner.isHidden = true
        spinner.stopAnimating()
        // enable exiting keyboard with tap

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
