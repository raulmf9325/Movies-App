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
    
    var delegate: FeaturedDelegate?
    
    var featuredMovies = [Movie]()
    var upcomingMovies = [Movie]()
    var inTheatersMovies = [Movie]()
    
    var searchResult = [Movie]()
    
    var featuredPage = 11
    var upcomingPage = 11
    var inTheatersPage = 11
    
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
    
    // for transition animator
    var selectedFrame: CGRect?
    
    init(featuredMovies: [Movie], upcomingMovies: [Movie], inTheatersMovies: [Movie]){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.featuredMovies.append(contentsOf: featuredMovies)
        self.upcomingMovies.append(contentsOf: upcomingMovies)
        self.inTheatersMovies.append(contentsOf: inTheatersMovies)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    override func viewDidLoad() {
        setupCollectionView()
        navigationController?.delegate = self
    }
    
    private func setupCollectionView(){
        category = .featured
        navBar = NavigationBar(delegate: self, viewController: self)
        searchTextField.addTarget(self, action: #selector(textDidChange), for: UIControl.Event.editingChanged)
        setupScreenEdgeSwipe()
        
        layoutState = .icons
        
        collectionView.backgroundColor = .black
        collectionView.register(IconFeaturedCell.self, forCellWithReuseIdentifier: "IconFeaturedCellId")
        collectionView.register(GridFeaturedCell.self, forCellWithReuseIdentifier: "GridFeaturedCellId")
        
        // Space Between Cells
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 10
    }
    
    // Refresh all three movie categories with fresh content from the server
   
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
        let title = navBar.navBarTitle.text!
        searchTextField.text = ""
        navBar.navBar.removeFromSuperview()
        navBar = NavigationBar(delegate: self, viewController: self)
        navBar.navBarTitle.text = title
        searchResult = [Movie]()
        collectionView.reloadData()
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
        // ongoing search
        if searchResult.count > 0{
            return searchResult.count
        }
        else if category == .featured{
            return featuredMovies.count
        }
        else if category == .upcoming{
            return upcomingMovies.count
        }
        else{
            return inTheatersMovies.count
        }
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
     
        cell.movie = movieForCellAtIndex(index: indexPath.item)
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
        
        movieDetails.navigationDelegate = self
        movieDetails.movie = movieForCellAtIndex(index: indexPath.item)
        
        let selectedFrame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height)
        
        pushController(selectedFrame: selectedFrame, vc: movieDetails)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchTextField.resignFirstResponder()
        
        var count = 0
  
        if searchResult.count > 0{
            count = searchResult.count
        }
        else if category == .featured{
            count = featuredMovies.count
        }
        else if category == .upcoming{
            count = upcomingMovies.count
        }
        else{
            count = inTheatersMovies.count
        }
        
        if let lastVisibleCell = collectionView.cellForItem(at: IndexPath(item: count - 1, section: 0)){
            fetchNewContent()
        }
    }
    
    private func movieForCellAtIndex(index: Int) -> Movie{
        var movie = Movie()
        
        if searchResult.count > 0{
            movie = searchResult[index]
        }
        else if category == .featured{
            movie = featuredMovies[index]
        }
        else if category == .upcoming{
            movie = upcomingMovies[index]
        }
        else{
            movie = inTheatersMovies[index]
        }
        
        return movie
    }
    
    private func fetchNewContent(){
        let title = navBar.navBarTitle.text
        
        /*  To Do
         */
        // search
        if searchResult.count > 0{
            
        }
        
        // Featured
        if title == "Featured"{
            Service.shared.fetchFeatured(featuredPage) { (movies) in
                self.featuredMovies.append(contentsOf: movies)
                self.featuredPage += 1
                self.collectionView.reloadData()
            }
        }
        
        // In Theaters
        else if title == "In Theaters"{
            Service.shared.fetchInTheaters(page: inTheatersPage) { (movies) in
                self.inTheatersMovies.append(contentsOf: movies)
                self.inTheatersPage += 1
                self.collectionView.reloadData()
            }
        }
        
        // Upcoming
       else if title == "Upcoming"{
            Service.shared.fetchUpcoming(page: upcomingPage) { (movies) in
                self.upcomingMovies.append(contentsOf: movies)
                self.upcomingPage += 1
                self.collectionView.reloadData()
            }
        }
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
            searchResult = [Movie]()
            collectionView.reloadData()
            return
        }
        
        Service.shared.fetchMoviesWithQuery(query: queryText) { (movies) in
            self.searchResult = movies
            self.collectionView.performBatchUpdates({
                let indexSet = IndexSet(integersIn: 0...0)
                self.collectionView.reloadSections(indexSet)
            }, completion: nil)
            
            if self.searchResult.count > 0{
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.bottom, animated: false)
            }
            self.searchTextField.becomeFirstResponder()
            self.searchTextField.text = text
        }
    }
    
    func categoryDidChange(category: String){
        navBar.navBarTitle.text = category
        
        if(category == "Featured"){
            self.category = .featured
        }
        else if(category == "Upcoming"){
            self.category = .upcoming
        }
        else if(category == "In Theaters"){
            self.category = .inTheaters
        }
        
        collectionView.performBatchUpdates({
            let indexSet = IndexSet(integersIn: 0...0)
            self.collectionView.reloadSections(indexSet)
        }, completion: nil)
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.bottom, animated: false)
    }
}


// MARK: Featured Delegate
protocol FeaturedDelegate {
    func toggleMenu()
    func categoryDidChange(category: String)
    func handleSreenEdgeSwipe()
}

/*  Custom Transition Animation
 */
extension Featured: UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let frame = selectedFrame else {return nil}
        
        switch operation{
        case .push:
            return TransitionAnimator(duration: 0.2, isPresenting: true, originFrame: frame)
        default:
            return TransitionAnimator(duration: 0.2, isPresenting: false, originFrame: frame)
        }
    }
    
}

protocol NavigationDelegate{
    func pushController(selectedFrame: CGRect, vc: UIViewController)
    func pop(originFrame: CGRect?, animated: Bool)
}

extension Featured: NavigationDelegate{
    func pushController(selectedFrame: CGRect, vc: UIViewController){
        self.selectedFrame = selectedFrame
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pop(originFrame: CGRect?, animated: Bool){
        if originFrame != nil{
            self.selectedFrame = originFrame!
        }
        
        navigationController?.popViewController(animated: animated)
    }
}
