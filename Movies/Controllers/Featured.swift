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
    
    // Number of Items In Section
    var numberOfItemsInSection: Int!
    
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
    let navBarTitle: UILabel = {
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
    
    // Search Text Field
    let searchTextField: UITextField = {
        let textField = UITextField()
        let font =  UIFont(name: "HelveticaNeue", size: 12)
        textField.attributedPlaceholder = NSAttributedString(string: "      movie, actor", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: font ])
        textField.font = font
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .white
        return textField
    }()
    
    enum gridState{
        case grid
        case icons
    }
    
    var layoutState: gridState!
    
    
    // view did load
    override func viewDidLoad() {
        numberOfItemsInSection = 31
        setupCollectionView()
        setupNavigationBar()
    }
    
    // SetUp Collection View
    private func setupCollectionView(){
        collectionView.backgroundColor = .black
        layoutState = .icons
        collectionView.register(IconFeaturedCell.self, forCellWithReuseIdentifier: "IconFeaturedCellId")
        collectionView.register(GridFeaturedCell.self, forCellWithReuseIdentifier: "GridFeaturedCellId")
        
        // Space Between Cells
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 10
    }
    
    
    // setting up navigation Bar
    private func setupNavigationBar(){
      
        // hide native navigation bar
        navigationController?.isNavigationBarHidden = true
        
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
    
    @objc func handleIconView(){
        if layoutState == .icons{
            layoutState = .grid
            navBarIconView.image = UIImage(named: "gridView")
        }
        else{
            layoutState = .icons
            navBarIconView.image = UIImage(named: "iconView")
        }
        UIView.animate(withDuration: 0.2) {
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
        }
    }
    
    // MARK: toggle menu
    @objc private func handleHamburgerTap(){
        if searchTextField.isFirstResponder{
            dismissSearch()
        }
        delegate?.toggleMenu()
    }
    
    // Search Text Field Container View
    let searchBoxContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    // Overlay View For Disabling User Intercation With Collection View
    let overlayView: UIView = {
        let view = UIView()
        return view
    }()
    
    // List of Visible Cells
    var listOfVisibleCells: [IndexPath]!
    
    // MARK: insert search box
    @objc private func handleMagnifierTap(){
       
        // Retrieve List of Currently Visible Cells
        listOfVisibleCells = collectionView.indexPathsForVisibleItems.sorted()
        // First Visible Cell
        guard var firstCell = collectionView.cellForItem(at: listOfVisibleCells[0]) else {return}
        
        // If First Visible Cell is Obscured By Nav Bar
        var constant: CGFloat = -77
        if layoutState == .grid{
            constant = -165
        }
        if firstCell.frame.origin.y - collectionView.contentOffset.y < constant{
            firstCell = collectionView.cellForItem(at: listOfVisibleCells[3])!
        }
        
        // Container Frame Is Above First Cell
        let frame = firstCell.frame
        
        let y: CGFloat = frame.origin.y - 100
        let height: CGFloat = 100
        let width: CGFloat = view.frame.width
        let containerFrame = CGRect(x: 0, y: y, width: width, height: height)
        
        // Overlay Transparent View For Dismissal Of Search Box
        let relativeX: CGFloat = frame.origin.x
        let relativeY: CGFloat = frame.origin.y
        let rect = CGRect(x: relativeX, y: relativeY, width: view.frame.width, height: view.frame.height)
        overlayView.frame = rect
        collectionView.addSubview(overlayView)
        
        // Add Search Box
        searchBoxContainerView.frame = containerFrame
        collectionView.addSubview(searchBoxContainerView)
        searchBoxContainerView.addSubview(searchTextField)
        searchBoxContainerView.addConstraintsWithFormat(format: "H:|-70-[v0]-70-|", views: searchTextField)
        searchBoxContainerView.addConstraintsWithFormat(format: "V:[v0(35)]|", views: searchTextField)
        // Scroll To Search Box
        collectionView.scrollRectToVisible(containerFrame, animated: true)
        
        // Disable Collection View Scroll
        collectionView.isScrollEnabled = false
        // Disable Search Button While Search Box Is Active
        navBarRightButton.isUserInteractionEnabled = false
        // Add Gesture To Overlay View For Dismissal Of Search
        overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSearch)))
        // Bring Up Keyboard
        searchTextField.becomeFirstResponder()
        
    }
    
    // Dismiss Search
    @objc func dismissSearch(){
        // Animate Scroll Back
        UIView.animate(withDuration: 0.2, animations: {
            self.searchBoxContainerView.frame.origin.y -= 40
            self.searchTextField.resignFirstResponder()
        }) { (_) in
            // Remove Search Box and Overlay View
            // Re-enable Scroll and Search Button
            self.searchBoxContainerView.removeFromSuperview()
            self.overlayView.removeFromSuperview()
            self.collectionView.isScrollEnabled = true
            self.navBarRightButton.isUserInteractionEnabled = true
        }
    }
    
    
    
    // Number of Sections
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Number Of Items in Section
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection
    }
    
    // Cell for Item at IndexPath
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if layoutState == .icons{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconFeaturedCellId", for: indexPath) as! IconFeaturedCell
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridFeaturedCellId", for: indexPath) as! GridFeaturedCell
            return cell
        }
        
    }
    
    // Insets for Section 0
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 70, left: 10, bottom: 10, right: 10)
    }

    // Size of Cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spaceBetweenCells: CGFloat = 10
        let insets: CGFloat = 10
        var height = 160
        var numberOfCellsInRow: CGFloat = 3
        if layoutState == .grid{
            height = 270
            numberOfCellsInRow = 2
        }
        let width = Int ((view.frame.width - (2 * spaceBetweenCells + 2 * insets)) / numberOfCellsInRow)
        return CGSize(width: width, height: height)
    }
    
} // END: Featured Controller


// MARK: Featured Delegate
protocol FeaturedDelegate {
    func toggleMenu()
}
