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
    
    var featuredMovies = [Movie]()
    var upcomingMovies = [Movie]()
    var inTheatersMovies = [Movie]()
    
    var page = 3
    
    enum gridState{
        case grid
        case icons
    }
    
    enum categoryState{
        case featured
        case upcoming
        case inTheaters
    }
    
    var layoutState: gridState!
    var category: categoryState!
    
    var navBar: NavigationBar!
    
    // view did load
    override func viewDidLoad() {
        category = .featured
        setupCollectionView()
        navBar = NavigationBar(delegate: self, viewController: self)
        searchTextField.addTarget(self, action: #selector(textDidChange), for: UIControl.Event.editingChanged)
        setupScreenEdgeSwipe()
        refresh(page: 1)
    }
    
    // SetUp Collection View
    private func setupCollectionView(){
        layoutState = .icons
        
        collectionView.backgroundColor = .black
        collectionView.register(IconFeaturedCell.self, forCellWithReuseIdentifier: "IconFeaturedCellId")
        collectionView.register(GridFeaturedCell.self, forCellWithReuseIdentifier: "GridFeaturedCellId")
        
        // Space Between Cells
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 10
    }
    
    // Refresh all three movie categories with fresh content from the server
    private func refresh(page: Int){
        if page == 5{
            collectionView.reloadData()
            delegate?.finishedRefreshing()
            return
        }
        else{
            if page == 1{
                featuredMovies = [Movie]()
                upcomingMovies = [Movie]()
                inTheatersMovies = [Movie]()
            }
            Service.shared.fetchFeatured(page) { (featuredMovies) in
                Service.shared.fetchUpcoming(page: page, completion: { (upcomingMovies) in
                    Service.shared.fetchInTheaters(page: page, completion: { (inTheatersMovies) in
                        self.featuredMovies.append(contentsOf: featuredMovies)
                        self.upcomingMovies.append(contentsOf: upcomingMovies)
                        self.inTheatersMovies.append(contentsOf: inTheatersMovies)
                        self.refresh(page: page + 1)
                    })
                })
            }
        }
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
            self.collectionView.performBatchUpdates({
                let indexSet = IndexSet(integersIn: 0...0)
                self.collectionView.reloadSections(indexSet)
            }, completion: nil)
            
            self.collectionView.layoutIfNeeded()
        }
    }
    
    // MARK: reload
    func reload(){
        if navBar.navBarTitle.text == "Featured"{
            Service.shared.fetchFeatured(1) { (movies) in
                self.reloadHelper(movies: movies)
            }
        }
        else if navBar.navBarTitle.text == "Upcoming"{
            Service.shared.fetchUpcoming(page: 1) { (movies) in
                self.reloadHelper(movies: movies)
            }
        }
        else if navBar.navBarTitle.text == "In Theaters"{
            Service.shared.fetchInTheaters(page: 1) { (movies) in
                self.reloadHelper(movies: movies)
            }
        }
    }
    
    private func reloadHelper(movies: [Movie]){
        self.movies = movies
        
        self.collectionView.performBatchUpdates({
            let indexSet = IndexSet(integersIn: 0...0)
            self.collectionView.reloadSections(indexSet)
        }, completion: nil)
        
        if self.movies?.count ?? 0 > 0{
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.bottom, animated: false)
        }
    }

    
    // MARK: toggle menu
    func handleHamburgerTap(){
        if searchTextField.isFirstResponder{
            dismissSearch()
        }
        delegate?.toggleMenu()
    }
    
    // Overlay View For Disabling User Intercation With Collection View
    let overlayView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    // MARK: insert search box
    func handleMagnifierTap(){
        navBar.navBarLeftButton.removeFromSuperview()
        navBar.navBarRightButton.removeFromSuperview()
        navBar.navBarIconView.removeFromSuperview()
        navBar.navBarTitle.removeFromSuperview()
        
        let magnifierImageView = UIImageView(image: UIImage(named: "Magnifier"))
        navBar.navBar.addSubview(magnifierImageView)
        
        navBar.navBar.addConstraintsWithFormat(format: "H:|-16-[v0(25)]", views: magnifierImageView)
        navBar.navBar.addConstraintsWithFormat(format: "V:[v0(25)]-8-|", views: magnifierImageView)
        
        let cancelLabel = UILabel()
        cancelLabel.text = "Cancel"
        cancelLabel.textColor = .white
        cancelLabel.font = UIFont.systemFont(ofSize: 13)
        cancelLabel.isUserInteractionEnabled = true
        cancelLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSearch)))
        
        navBar.navBar.addSubview(searchTextField)
        navBar.navBar.addSubview(cancelLabel)
        navBar.navBar.addConstraintsWithFormat(format: "H:[v0]-16-[v1]-16-[v2]", views: magnifierImageView, searchTextField, cancelLabel)
        navBar.navBar.addConstraintsWithFormat(format: "[v0(50)]-16-|", views: cancelLabel)
        navBar.navBar.addConstraintsWithFormat(format: "V:[v0(30)]-8-|", views: searchTextField)
        navBar.navBar.addConstraintsWithFormat(format: "V:[v0(30)]-8-|", views: cancelLabel)
        
        searchTextField.addTarget(self, action: #selector(textDidChange(textField:)), for: UIControl.Event.editingChanged)
        searchTextField.becomeFirstResponder()
        
        collectionView.addSubview(overlayView)
        overlayView.frame = collectionView.frame
        overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    // Dismiss Search
    @objc func dismissSearch(){
        reload()
        let title = navBar.navBarTitle.text!
        searchTextField.text = ""
        navBar.navBar.removeFromSuperview()
        navBar = NavigationBar(delegate: self, viewController: self)
        navBar.navBarTitle.text = title
    }
    
    @objc func dismissKeyboard(){
        overlayView.removeFromSuperview()
        searchTextField.resignFirstResponder()
    }
        
    // Number of Sections
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Number Of Items in Section
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let numberOfItemsInSection = movies?.count else {return 0}
        return numberOfItemsInSection
    }
    
    // Cell for Item at IndexPath
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: BaseFeaturedCell
        
        if layoutState == .icons{
             cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconFeaturedCellId", for: indexPath) as! IconFeaturedCell
        }
        else{
             cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridFeaturedCellId", for: indexPath) as! GridFeaturedCell
        }
        
        cell.movie = movies?[indexPath.item]
        return cell
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
        
        let cell = collectionView.cellForItem(at: indexPath) as! BaseFeaturedCell
        
        let movieDetails = MovieDetails(collectionViewLayout: StretchyHeaderLayout())
        
        movieDetails.cast = cell.cast
        movieDetails.movie = movies?[indexPath.item]
        
        navigationController?.pushViewController(movieDetails, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchTextField.resignFirstResponder()
        
        guard let count = movies?.count else {return}
        if let lastVisibleCell = collectionView.cellForItem(at: IndexPath(item: count - 1, section: 0)){
            updateCollectionWithNewContent()
        }
    }
    
    private func updateCollectionWithNewContent(){
        let title = navBar.navBarTitle.text
        
        // Featured
        if title == "Featured"{
            Service.shared.fetchFeatured(page) { (movies) in
                let pageOne = movies
                Service.shared.fetchFeatured(self.page + 1, completion: { (movies) in
                    let pageTwo = movies
                    self.movies?.append(contentsOf: pageOne + pageTwo)
                })
            }
        }
        
        // In Theaters
        else if title == "In Theaters"{
            Service.shared.fetchInTheaters(page: page) { (movies) in
                self.movies?.append(contentsOf: movies)
            }
        }
        
        // Upcoming
       else if title == "Upcoming"{
            Service.shared.fetchUpcoming(page: page) { (movies) in
                self.movies?.append(contentsOf: movies)
            }
        }
        
         page += 2
    }
    
    // Swipe-Back On Screen Edge Support
    private func setupScreenEdgeSwipe(){
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            delegate?.handleSreenEdgeSwipe()
        }
    }
    
    // Search Text Field
    let searchTextField: UITextField = {
        let textField = UITextField()
        let font =  UIFont(name: "HelveticaNeue", size: 12)
        textField.attributedPlaceholder = NSAttributedString(string: "     movie", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: font ])
        textField.font = font
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .white
        return textField
    }()
    
} // END: Featured Controller


extension Featured{
    
    @objc func textDidChange(textField: UITextField){
        
        guard let text = textField.text else {return}
        var queryText = text.replacingOccurrences(of: " ", with: "+")
        
        if queryText.count == 0{
            reload()
            return
        }
        
        Service.shared.fetchMoviesWithQuery(query: queryText) { (movies) in
            self.movies = movies
            self.collectionView.performBatchUpdates({
                let indexSet = IndexSet(integersIn: 0...0)
                self.collectionView.reloadSections(indexSet)
            }, completion: nil)
            
            if self.movies?.count ?? 0 > 0{
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.bottom, animated: false)
            }
            self.searchTextField.becomeFirstResponder()
            self.searchTextField.text = text
        }
    }
}

// MARK: Featured Delegate
protocol FeaturedDelegate {
    func toggleMenu()
    func finishedRefreshing()
    func updateMoviesBasedOnMenu(movies: [Movie], title: String)
    func handleSreenEdgeSwipe()
}
