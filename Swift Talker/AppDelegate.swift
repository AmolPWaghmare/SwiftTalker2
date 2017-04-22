//
//  AppDelegate.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 14/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Set Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.0, green: 166.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        
        if User.currentUser != nil {
            print("Already a user")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let hamburgerViewController = storyboard.instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController
            
            let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            
            hamburgerViewController.menuViewController = menuViewController
            menuViewController.hamburgerViewController = hamburgerViewController
            
            window?.rootViewController = hamburgerViewController
            
        }

        NotificationCenter.default.addObserver(forName: .userDidLogoutNotificationName, object: nil, queue: OperationQueue.main) { (notification: Notification!) in
                print("UserDidlogout")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateInitialViewController()
            
            self.window?.rootViewController = viewController

        }
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        TwitterClient.sharedInstance?.handleOpenURL(url: url)
        
        return true
    }


}

