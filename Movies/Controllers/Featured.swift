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
    var movies: [Movie]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    // for query of Movies
    var queryMovies: [Movie]?
    
    var page = 1
    
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
    
    enum gridState{
        case grid
        case icons
    }
    
    var layoutState: gridState!
    
    var navBar: NavigationBar!
    
    
    // view did load
    override func viewDidLoad() {
        setupCollectionView()
        setupNavigationBar()
        setupTextField()
    }
    
    private func setupTextField(){
        searchTextField.addTarget(self, action: #selector(textDidChange), for: UIControl.Event.editingChanged)
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
            self.collectionView.performBatchUpdates({
                let indexSet = IndexSet(integersIn: 0...0)
                self.collectionView.reloadSections(indexSet)
            }, completion: nil)
            
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
        Service.shared.fetchJSON(page: 1) { (movies) in
            self.movies = movies
            self.collectionView.performBatchUpdates({
                let indexSet = IndexSet(integersIn: 0...0)
                self.collectionView.reloadSections(indexSet)
            }, completion: nil)
        }
        searchTextField.text = ""
        navBar.navBar.removeFromSuperview()
        navBar = NavigationBar(delegate: self, viewController: self)
    }
    
    @objc func dismissKeyboard(){
        overlayView.removeFromSuperview()
        searchTextField.resignFirstResponder()
    }
    
    // Flush cache
    override func didReceiveMemoryWarning() {
        BaseFeaturedCell.cache.removeAllObjects()
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
        
        //cell.imageView.image = posters?[indexPath.item]
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
        
        let movieDetails = MovieDetails(collectionViewLayout: StretchyHeaderLayout())
      
        movieDetails.movie = movies?[indexPath.item]
        
        if let id = movies?[indexPath.item].id{
            Service.shared.fetchMovieDetails(movieId: id) { (details) in
                movieDetails.details = details
            }
        }
        
        if let genres = movies?[indexPath.item].genre_ids{
            var genreString = ""
            for index in 0 ... 2{
                if index + 1 <= genres.count{
                    genreString.append(contentsOf: "\(genres[index]),")
                }
            }
            Service.shared.fetchMoviesWithGenres(genres: genreString) { (similarMovies) in
                var similar = [Movie]()
                for movie in similarMovies{
                    if movie.title != self.movies?[indexPath.item].title{
                        similar.append(movie)
                    }
                }
                movieDetails.similarMovies = similar
            }
        }
        navigationController?.pushViewController(movieDetails, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        searchTextField.resignFirstResponder()
        
        guard let numberOfMovies = movies?.count else {return}
        
        if let lastCell = collectionView.cellForItem(at: IndexPath(item: numberOfMovies - 1, section: 0)){
            page += 1
            Service.shared.fetchJSON(page: page) { (movies) in
                self.movies?.append(contentsOf: movies)
                self.collectionView.reloadData()
            }
        }
    }
    
} // END: Featured Controller


extension Featured{
    
    @objc func textDidChange(textField: UITextField){
        
        guard let text = textField.text else {return}
        var queryText = text.replacingOccurrences(of: " ", with: "+")
        
        Service.shared.fetchMoviesWithQuery(query: queryText) { (movies) in
            self.movies = movies
            self.collectionView.performBatchUpdates({
                let indexSet = IndexSet(integersIn: 0...0)
                self.collectionView.reloadSections(indexSet)
            }, completion: nil)
            
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.bottom, animated: false)
            self.searchTextField.becomeFirstResponder()
            self.searchTextField.text = text
        }
        
    }
    
}


// MARK: Featured Delegate
protocol FeaturedDelegate {
    func toggleMenu()
    func updateMoviesBasedOnMenu(movies: [Movie], title: String)
}
