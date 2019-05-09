//
//  constants.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/14/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionHandler = (_ Success: Bool) -> ()

// URL Constants
let BASE_URL = "http://41.226.11.252:1180/psypocket/"
let URL_QUESTIONS = "\(BASE_URL)questionRep.php"
let URL_LOGIN = "\(BASE_URL)login13.php"
let URL_REGISTER = "\(BASE_URL)inscrit.php"

// Notification Constants
// let NOTIF_DEVICE_DATA_DID_CHANGE = Notification.Name("notifDeviceDataChanged")
// let NOTIF_DEVICES_ADDED = Notification.Name("addedNewDevices")
// Segues
let LOGIN_TO_MENU = "loginToMenu"
let REGISTER_TO_MENU = "registerToMenu"
let MENU_TO_REGISTER = "MenuToLogin"


// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"
let USER_FULLNAME = "userFullName"
let USER_NAME = "username"
let SELECTED_DEVICE = "selectedDevice"
let IMAGE_URL = "imageUrl"

// Headers
let HEADER = [
    "Content-Type": "application/json"
]


extension UIColor {
    
    // Setup custom colours we can use throughout the app using hex values
    static let seemuBlue = UIColor(hex: 0x00adf7)
    static let youtubeRed = UIColor(hex: 0xf80000)
    static let transparentBlack = UIColor(hex: 0x000000, a: 0.5)
    static let lightpink = UIColor(red: 215 , green: 74 , blue: 82)
    static let lightblue = UIColor(red: 0 , green: 198 , blue: 255)
    // Create a UIColor from RGB
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    // Create a UIColor from a hex value (E.g 0x000000)
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}
extension Collection where Element: Numeric {
    /// Returns the total sum of all elements in the array
    var total: Element { return reduce(0, +) }
}

