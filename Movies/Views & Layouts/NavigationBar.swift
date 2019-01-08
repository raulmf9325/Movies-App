//
//  NavigationBar.swift
//  Movies
//
//  Created by Raul Mena on 12/25/18.
//  Copyright © 2018 Raul Mena. All rights reserved.
//

import UIKit

class NavigationBar{
    
    var delegate: NavigationProtocol!
    var viewController: UIViewController!
    
    init(delegate: NavigationProtocol, viewController: UIViewController) {
       self.delegate = delegate
       self.viewController = viewController
       setupNavigationBar()
    }
    
    // setting up navigation Bar
    private func setupNavigationBar(){
        
        // hide native navigation bar
        viewController.navigationController?.isNavigationBarHidden = true
        
        guard let view = viewController.view else {return}
        
        // add navBar view
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        // add blurEffect to navBar
        let blur = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blur)
        navBar.addSubview(effectView)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.widthAnchor.constraint(equalTo: navBar.widthAnchor).isActive = true
        effectView.heightAnchor.constraint(equalTo: navBar.heightAnchor).isActive = true
        
        // Add NavBar leftButton And IconView Button
        navBar.addSubview(navBarLeftButton)
        navBar.addSubview(navBarIconView)
        navBar.addConstraintsWithFormat(format: "H:|-20-[v0(30)]-25-[v1(23)]", views: navBarLeftButton, navBarIconView)
        navBar.addConstraintsWithFormat(format: "V:[v0(30)]-8-|", views: navBarLeftButton)
        navBar.addConstraintsWithFormat(format: "V:[v0(23)]-11-|", views: navBarIconView)
        navBarLeftButton.addTarget(self, action: #selector(handleHamburgerTap), for: .touchUpInside)
        navBarIconView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleIconView)))
        
        // add navBar title
        navBar.addSubview(navBarTitle)
        let center = view.frame.width / 2
        navBar.addConstraintsWithFormat(format: "H:|-\(center - 40)-[v0]", views: navBarTitle)
        navBar.addConstraintsWithFormat(format: "V:[v0]-12-|", views: navBarTitle)
        
        // add navBar rightButton
        navBar.addSubview(navBarRightButton)
        navBar.addConstraintsWithFormat(format: "H:[v0(30)]-20-|", views: navBarRightButton)
        navBar.addConstraintsWithFormat(format: "V:[v0(30)]-8-|", views: navBarRightButton)
        navBarRightButton.addTarget(self, action: #selector(handleMagnifierTap), for: .touchUpInside)
    }
    
    @objc func handleHamburgerTap(){
        delegate.handleHamburgerTap()
    }
    
    @objc func handleMagnifierTap(){
        delegate.handleMagnifierTap()
    }
    
    @objc func handleIconView(){
        delegate.handleIconView()
    }
    
    // navBar view
    let navBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return bar
    }()
    
    // navBar left button
    let navBarLeftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Hamburger"), for: .normal)
        return button
    }()
    
    // navBar iconView button
    let navBarIconView: UIImageView = {
        let image = UIImage(named: "iconView")
        let imageView = UIImageView(image: image)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // navBar title
    var navBarTitle: UILabel = {
        let title = UILabel()
        title.text = "Featured"
        title.font = UIFont(name: "HelveticaNeue", size: 20)
        title.textColor = .white
        return title
    }()
    
    // navBar RightButtn
    let navBarRightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Magnifier"), for: .normal)
        return button
    }()
}
