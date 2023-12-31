//
//  AppDelegate.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/13.
//

import UIKit
import IQKeyboardManagerSwift
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIView.appearance().backgroundColor = .clear
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        
        IQKeyboardManager.shared.enable = true
        
//        let modifier = AnyModifier { request in
//            var req = request
//            req.addValue(UserDefaults.token, forHTTPHeaderField: "Authorization")
//            req.addValue(APIManagement.key, forHTTPHeaderField: "SesacKey")
//            return req
//        }
//        KingfisherManager.shared.defaultOptions += [
//            .requestModifier(modifier)
//        ]
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

