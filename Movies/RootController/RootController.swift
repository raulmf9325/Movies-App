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
    var navBar: NavigationBar!
    
    var movies: [Movie]?{
        didSet{
            featured.movies = movies
        }
    }
    
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
    
    fileprivate func setupViews(){
        // instantiate featured and menu controllers
        featured = Featured(collectionViewLayout: UICollectionViewFlowLayout())
        featuredNavigationController = UINavigationController(rootViewController: featured)
        featured.delegate = self
        featured.movies = movies
        
        menu = Menu()
        menu.delegate = self
        
        // insert featured and menu as views in container viewController
        view.insertSubview(menu.view, at: 0)
        view.addSubview(featuredNavigationController.view)
    }
    
    fileprivate func setupNavigationBar(){
        navBar = NavigationBar(delegate: self, viewController: self)
    }

    
} // End of RootController


extension RootController: FeaturedDelegate{
   
   @objc func toggleMenu() {
    
        // Menu is Collapsed
        if menuState == .collapsed{
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut, animations: {
                            self.featuredNavigationController.view.frame.origin.x = self.view.frame.width - self.menuExpandedOffSet
                            self.featured.navBar.navBar.frame.origin.x = 16
            }, completion: nil)
            // Mark Menu as Expanded
            menuState = .expanded
            // Disable FeaturedController Interaction
            featured.collectionView.isUserInteractionEnabled = false
            // ADD Tap Gesture For Collapsing Menu
            featuredNavigationController.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleMenu)))
        }
        // Menu is Expanded
        else{
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut, animations: {
                            self.featuredNavigationController.view.frame.origin.x = 0
                            self.featured.navBar.navBar.frame.origin.x = 0
            }, completion: nil)
            // Mark Menu as Collapsed
            menuState = .collapsed
            // Enable FeaturedController Interaction
            featured.collectionView.isUserInteractionEnabled = true
            // REMOVE Tap Gesture
            if let gestureRecognizers = featuredNavigationController.view.gestureRecognizers{
                for gesture in gestureRecognizers{
                    if gesture is UITapGestureRecognizer{
                        featuredNavigationController.view.removeGestureRecognizer(gesture)
                    }
                }
            }
        }
    }
    
    func updateMoviesBasedOnMenu(movies: [Movie], title: String) {
        featured.movies = movies
        featured.navBar.navBarTitle.text = title
        
        featured.collectionView.performBatchUpdates({
            let indexSet = IndexSet(integersIn: 0...0)
            self.featured.collectionView.reloadSections(indexSet)
        }, completion: nil)
        
        featured.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.bottom, animated: false)
        
        toggleMenu()
    }
    
} // End of Extensiom

extension RootController: NavigationProtocol{
    
     func handleHamburgerTap(){
        featured.handleHamburgerTap()
    }
    
     func handleIconView(){
        featured.handleIconView()
    }
    
     func handleMagnifierTap(){
        featured.handleMagnifierTap()
    }
    
    func handleSreenEdgeSwipe() {
        featured.handleHamburgerTap()
    }
}
