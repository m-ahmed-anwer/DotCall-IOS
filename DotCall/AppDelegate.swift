//
//  AppDelegate.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-04-22.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        do{
            let realm = try Realm()
        }catch{
            print("Error in initializing Realm")
        }
        

        return true
    }



    func applicationWillTerminate(_ application: UIApplication) {
        
    }

    
//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//
//    }


}

