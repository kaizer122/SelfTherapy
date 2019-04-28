//
//  AppDelegate.swift
//  SmartInterphone
//
//  Created by Ladjemi Kais on 2/7/19.
//  Copyright © 2019 iof. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import CoreData
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , GIDSignInDelegate {
    
    
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //firebase
           FirebaseApp.configure()
        // facebook
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
        // google
        GIDSignIn.sharedInstance()?.clientID = "85103153019-7qe42kd70v0lg45su7jl7o3g6lm9s927.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        // login control
        if (AuthService.instance.isLoggedIn) {
     let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
     let startVC = storyBoard.instantiateViewController(withIdentifier: "StartVC") as! StartVC
        self.window?.rootViewController = startVC
            self.window?.makeKeyAndVisible()
        }
    
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let returnFB = FBSDKApplicationDelegate.sharedInstance().application(app, open: url , options: options)
        let returnGoogle =  GIDSignIn.sharedInstance().handle(url as URL?,
                                                              sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                              annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return returnFB || returnGoogle
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        GIDSignIn.sharedInstance().signOut()
        if let error = error {
            debugPrint("could not login with google :\(error.localizedDescription)")
        } else {
            print ("logged in with google")
        
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    return
                }
                AuthService.instance.userEmail = Auth.auth().currentUser!.email!
                AuthService.instance.username = Auth.auth().currentUser!.displayName!
                AuthService.instance.isLoggedIn = true
                debugPrint(AuthService.instance.userEmail)
                debugPrint(AuthService.instance.username)
                if ((GIDSignIn.sharedInstance()?.uiDelegate as? LoginVC) != nil ) {
                                    guard let loginC = GIDSignIn.sharedInstance()?.uiDelegate as? LoginVC else {return}
                                   loginC.performSegue(withIdentifier: LOGIN_TO_MENU , sender: self)
                    
                                }
                
            }
            
        }
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
   
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    
    
    
    
}


