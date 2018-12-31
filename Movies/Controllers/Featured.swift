//
//  Featured.swift
//  Movies
//
//  Created by Raul Mena on 12/9/18.
//  Copyright © 2018 Raul Mena. All rights reserved.
//

import UIKit

// MARK: Featured view controller
class Featured: UICollectionViewController, UICollectionViewDelegateFlowLayout, NavigationProtocol{
    
    // delegate object for handling callbacks
    var delegate: FeaturedDelegate?
    
    // Number of Items In Section
    var numberOfItemsInSection: Int!
    
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
    
    var navBar: NavigationBar!
    
    
    // view did load
    override func viewDidLoad() {
        numberOfItemsInSection = 31
        setupCollectionView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar(){
        navBar = NavigationBar(delegate: self, viewController: self)
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
    
    func handleIconView(){
        if layoutState == .icons{
            layoutState = .grid
            navBar.navBarIconView.image = UIImage(named: "gridView")
        }
        else{
            layoutState = .icons
            navBar.navBarIconView.image = UIImage(named: "iconView")
        }
        UIView.animate(withDuration: 0.2) {
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
        }
    }
    
    // MARK: toggle menu
    func handleHamburgerTap(){
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
    func handleMagnifierTap(){
        
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
        navBar.navBarRightButton.isUserInteractionEnabled = false
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
            self.navBar.navBarRightButton.isUserInteractionEnabled = true
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
    
    // Present Movie Details
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetails = MovieDetails(collectionViewLayout: StretchyHeaderLayout())
        navigationController?.pushViewController(movieDetails, animated: true)
    }
    
} // END: Featured Controller


// MARK: Featured Delegate
protocol FeaturedDelegate {
    func toggleMenu()
}
