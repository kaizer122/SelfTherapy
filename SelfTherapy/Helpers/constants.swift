//
//  constants.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/14/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import Foundation

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




