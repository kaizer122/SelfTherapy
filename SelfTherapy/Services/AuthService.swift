//
//  AuthService.swift
//  SmartInterphone
//
//  Created by Ladjemi Kais on 2/15/19.
//  Copyright © 2019 iof. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class AuthService {
    static let instance = AuthService()
    let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
 
    
    var username: String {
        get {
            return defaults.value(forKey: USER_NAME) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_NAME)
        }
    }

    func registerUser(email: String, password: String, username : String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "username": username,
            "password": password,
            "email": lowerCaseEmail,
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body).responseJSON { (response) in
            print ("request ok")
            if response.result.error == nil {
                print ("error ok")
              
       
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
            ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body).responseString { (response) in
          
            if response.result.error == nil {
                let data = response.result.value
                debugPrint(data)
                if ( (data?.contains("true"))! ) {
                    self.username = email
                    self.userEmail = email
                    self.isLoggedIn = true

                    completion(true)
                } else {
                    completion(false)
                }
                }
             else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func logoutUser () {
        userEmail = ""
        username = ""
        isLoggedIn = false
        let fbloginManager =  FBSDKLoginManager()
        
        fbloginManager.logOut()
        GIDSignIn.sharedInstance().signOut()
    }
    
    
}
