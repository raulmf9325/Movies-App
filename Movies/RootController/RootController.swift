//
//  RootController.swift
//  Movies
//
//  Created by Raul Mena on 12/9/18.
//  Copyright © 2018 Raul Mena. All rights reserved.
//

import UIKit

class RootController: UIViewController{
    
    var menu: Menu!
    var featured: Featured!
    var featuredNavigationController: UINavigationController!
    let menuExpandedOffSet: CGFloat = 130
    
    enum SlideOutState{
        case collapsed
        case expanded
    }
    
    var menuState: SlideOutState = .collapsed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    private func setupViews(){
        // instantiate featured and menu controllers
        featured = Featured(collectionViewLayout: UICollectionViewFlowLayout())
        featuredNavigationController  = UINavigationController(rootViewController: featured)
        featured.delegate = self
        menu = Menu()
        
        // insert featured and menu as views in container viewController
        view.insertSubview(menu.view, at: 0)
        view.addSubview(featuredNavigationController.view)
        
        // add featured as child controller
//        addChild(featured)
//        featured.didMove(toParent: self)
    }

    
} // End of RootController


extension RootController: FeaturedDelegate{
   
    func toggleMenu() {
        
        if menuState == .collapsed{
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut, animations: {
                            self.featuredNavigationController.view.frame.origin.x = self.view.frame.width - self.menuExpandedOffSet
            }, completion: nil)
            menuState = .expanded
        }
        else{
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut, animations: {
                            self.featuredNavigationController.view.frame.origin.x = 0
            }, completion: nil)
            menuState = .collapsed
        }
    }
    
} // End of Extensiom
