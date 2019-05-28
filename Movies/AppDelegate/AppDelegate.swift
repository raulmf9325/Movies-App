//
//  AppDelegate.swift
//  Movies
//
//  Created by Raul Mena on 12/9/18.
//  Copyright © 2018 Raul Mena. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // instance of root controller
        let rootController = RootController()

        Service.shared.fetchFeatured(1) { (movies) in
            let pageOne = movies
            Service.shared.fetchFeatured(2, completion: { (movies) in
                let pageTwo = movies
                rootController.movies = pageOne + pageTwo
            })
        }
        
        // App Key Window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        
        window?.rootViewController = rootController
        
        // customizing navigation bar
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = UIColor.black
        appearance.isTranslucent = false
        
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 20)]
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
       
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
      
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

