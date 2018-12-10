//
//  Featured.swift
//  Movies
//
//  Created by Raul Mena on 12/9/18.
//  Copyright © 2018 Raul Mena. All rights reserved.
//

import UIKit

// MARK: Featured view controller
class Featured: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    // delegate object for handling callbacks
    var delegate: FeaturedDelegate?
    
    // view did load
    override func viewDidLoad() {
        collectionView.backgroundColor = .black
        setupNavigationBar()
    }
    
    // setting up navigation Bar
    private func setupNavigationBar(){
        navigationItem.title = "Featured"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Hamburger")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleHamburgerTap))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Magnifier")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleMagnifierTap))
        
    }
    
    // MARK: toggle menu
    @objc private func handleHamburgerTap(){
       delegate?.toggleMenu()
    }
    
    // MARK: insert search box
    @objc private func handleMagnifierTap(){
        
    }
}

// MARK: Featured Delegate
protocol FeaturedDelegate {
    func toggleMenu()
}
