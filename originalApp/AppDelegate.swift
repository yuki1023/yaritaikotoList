//
//  AppDelegate.swift
//  originalApp
//
//  Created by Yamamoto Chisato on 2020/09/16.
//  Copyright © 2020 Yamamoto Chisato. All rights reserved.
//


import UIKit
import NCMB

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let applicationKey = "f76d56d12cfe992ecddc9b1448cf4c1650066b5056d91d1107169d77e5458194"
        let clientKey = "866612483b3e03612e1189f4390c71f913b14d4904f5e1c2448353ac9bb1e704"
        NCMB.setApplicationKey(applicationKey, clientKey: clientKey)
        
        let ud = UserDefaults.standard
        if ud.object(forKey: "userName") == nil {
            NCMBUser.enableAutomaticUser()
            NCMBUser.automaticCurrentUser { (user, error) in
                if error != nil {
                    print(error)
                } else {
                    ud.set(user?.objectId, forKey: "userName")
                    print(ud.object(forKey: "userName"))
                }
            }
        }

    
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}


