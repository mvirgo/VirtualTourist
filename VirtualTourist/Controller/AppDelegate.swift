//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by Michael Virgo on 5/23/20.
//  Copyright © 2020 mvirgo. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let dataController = DataController(modelName: "VirtualTourist")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        dataController.load()
        // Set data controller to initial selection screen
        let navController = window?.rootViewController as! UINavigationController
        let travelLocationsViewController = navController.topViewController as! TravelLocationsViewController
        travelLocationsViewController.dataController = dataController
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveMapPosition()
        DataHelper.saveData(dataController)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        saveMapPosition()
        DataHelper.saveData(dataController)
    }
    
    func saveMapPosition() {
        let navController = window?.rootViewController as! UINavigationController
        let travelLocationsViewController = navController.topViewController as! TravelLocationsViewController
        travelLocationsViewController.saveLastMapPosition()
    }

}

