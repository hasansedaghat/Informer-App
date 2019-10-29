//
//  AppDelegate.swift
//  Informer
//
//  Created by Hasan Sedaghat on 10/16/19.
//  Copyright © 2019 Hasan Sedaghat. All rights reserved.
//

import UIKit
import KVNProgress
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let HSProgressConfiguration = KVNProgressConfiguration()
        HSProgressConfiguration.statusFont = UIFont(name: "Vazir-FD.ttf", size: 16)
        HSProgressConfiguration.minimumErrorDisplayTime = 3
        HSProgressConfiguration.minimumSuccessDisplayTime = 2.8
        HSProgressConfiguration.circleSize = 50
        HSProgressConfiguration.circleStrokeForegroundColor = #colorLiteral(red: 0.9725490196, green: 0.6, blue: 0.01176470588, alpha: 1)
        HSProgressConfiguration.errorColor = #colorLiteral(red: 0.9725490196, green: 0.6, blue: 0.01176470588, alpha: 1)
        HSProgressConfiguration.successColor = #colorLiteral(red: 0.9725490196, green: 0.6, blue: 0.01176470588, alpha: 1)
        //HSProgressConfiguration.statusColor = #colorLiteral(red: 0.9529411765, green: 0.5803921569, blue: 0.3529411765, alpha: 1)
        HSProgressConfiguration.statusColor = #colorLiteral(red: 0.9725490196, green: 0.6, blue: 0.01176470588, alpha: 1)
        HSProgressConfiguration.stopColor = #colorLiteral(red: 0.9725490196, green: 0.6, blue: 0.01176470588, alpha: 1)
        HSProgressConfiguration.backgroundType = .blurred
        HSProgressConfiguration.backgroundTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7034275968)
        KVNProgress.setConfiguration(HSProgressConfiguration)
        
        return true
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
    
}

