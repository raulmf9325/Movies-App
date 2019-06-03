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
    var rootController: RootController!
    
    var featuredMovies = [Movie]()
    var upcomingMovies = [Movie]()
    var inTheatersMovies = [Movie]()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // App Key Window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        
        refresh(page: 1)
        
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

extension AppDelegate{
    func finishedRefreshing() {
        // instance of root controller
        rootController = RootController(featuredMovies: featuredMovies, upcomingMovies: upcomingMovies, inTheatersMovies: inTheatersMovies)
        window?.rootViewController = rootController
    }
    
    private func refresh(page: Int){
        if page == 11{
            finishedRefreshing()
            return
        }
        else{
            if page == 1{
                featuredMovies = [Movie]()
                upcomingMovies = [Movie]()
                inTheatersMovies = [Movie]()
            }
            Service.shared.fetchFeatured(page) { (featuredMovies, numOfPages) in
                Service.shared.fetchUpcoming(page: page, completion: { (upcomingMovies, numOfPages) in
                    Service.shared.fetchInTheaters(page: page, completion: { (inTheatersMovies, numOfPages) in
                        self.featuredMovies.append(contentsOf: featuredMovies ?? [Movie]())
                        self.upcomingMovies.append(contentsOf: upcomingMovies ?? [Movie]())
                        self.inTheatersMovies.append(contentsOf: inTheatersMovies ?? [Movie]())
                        self.refresh(page: page + 1)
                    })
                })
            }
        }
    }
}


