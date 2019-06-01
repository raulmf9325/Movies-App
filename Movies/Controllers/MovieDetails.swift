//
//  MovieDetails.swift
//  Movies
//
//  Created by Raul Mena on 12/14/18.
//  Copyright © 2018 Raul Mena. All rights reserved.
//

import UIKit

// MARK: MovieDetails Class
class MovieDetails: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var navigationDelegate: NavigationDelegate!
    
    var numberOfItemsInSection = 0
    
    var movieName: String?
    var moviePosterURL: URL?
    var headerPosterURL: URL?
    var movieRating: Double?
    var releaseDate: String?
    var plot: String?
    var cast: [Cast]?
    
    var movie: Movie?{
        didSet{
            if let path = movie?.poster_path{
                let stringURL = "https://image.tmdb.org/t/p/w500/\(path)"
                moviePosterURL = URL(string: stringURL)
            }
  
            if let headerPosterPath = movie?.backdrop_path{
                let stringURL = "https://image.tmdb.org/t/p/w1280/\(headerPosterPath)"
                headerPosterURL = URL(string: stringURL)
            }
            
            movieName = movie?.title
            movieRating = movie?.vote_average
            releaseDate = movie?.release_date
            plot = movie?.overview
           // collectionView.reloadData()
        }
    }
    
    let headerId = "headerId"
    
    enum animationState{
        case Animated
        case notAnimated
    }
    
    var animatedCells = [animationState]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
        setupScreenEdgeSwipe()
    }
    
    private func setupScreenEdgeSwipe(){
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            handleBackButtonTap()
        }
    }
    
    fileprivate func setupCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "temporary")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView.register(FirstDetailCell.self, forCellWithReuseIdentifier: "FirstCellId")
        collectionView.register(SecondDetailCell.self, forCellWithReuseIdentifier: "SecondCellId")
        collectionView.register(ThirdDetailCell.self, forCellWithReuseIdentifier: "ThirdCellId")
        collectionView.register(FourthDetailCell.self, forCellWithReuseIdentifier: "FourthCellId")
        collectionView.register(FifthDetailCell.self, forCellWithReuseIdentifier: "FifthCellId")
    }
    
    private func setupNavigationBar(){
        // hide native navigation bar
        navigationController?.isNavigationBarHidden = true
        
        // add navBar view
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        // Add NavBar leftButton
        navBar.addSubview(navBarLeftButton)
        navBar.addConstraintsWithFormat(format: "H:|-20-[v0(30)]", views: navBarLeftButton)
        navBar.addConstraintsWithFormat(format: "V:[v0(30)]-8-|", views: navBarLeftButton)
        navBarLeftButton.addTarget(self, action: #selector(handleBackButtonTap), for: .touchUpInside)

        // add navBar title
        navBar.addSubview(navBarTitle)
        navBar.addConstraintsWithFormat(format: "H:[v0]-1-[v1]|", views: navBarLeftButton, navBarTitle)
        navBar.addConstraintsWithFormat(format: "V:[v0]-12-|", views: navBarTitle)
        navBarTitle.text = movieName
        if(movieName?.count ?? 0 > 38){
            navBarTitle.font = UIFont.systemFont(ofSize: 14)
        }
        else if(movieName?.count ?? 0 > 25){
            navBarTitle.font = UIFont.systemFont(ofSize: 16)
        }
        else{
            navBarTitle.font = UIFont.systemFont(ofSize: 20)
        }
    }
    
    @objc func handleBackButtonTap(){
        let originFrame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height)
        navigationDelegate.pop(originFrame: originFrame, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        if plot != nil && ((plot?.count ?? 0) > 0){
//            numberOfItemsInSection += 1
//        }
//
//        if cast != nil{
//            numberOfItemsInSection += 1
//        }
//
        return numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if numberOfItemsInSection == 0{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "temporary", for: indexPath)
            header.backgroundColor = .white
            return header
            
        }
        else{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderView
            header.posterImageURL = headerPosterURL
            return header
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        animatedCells.append(animationState.notAnimated)
        
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstCellId", for: indexPath) as! FirstDetailCell
            cell.movieID = movie?.id
            cell.movieNameLabel.text = movieName
            cell.posterURL = moviePosterURL
            cell.movieRating = movieRating
            return cell
        }
        
        if indexPath.row == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondCellId", for: indexPath) as! SecondDetailCell
            cell.releaseDate.text = releaseDate
            cell.movieID = movie?.id
            cell.trailerDelegate = self
            return cell
        }
        
        if indexPath.row == 2{
            if plot == nil || plot?.count == 0{
                if cast != nil{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FourthCellId", for: indexPath) as! FourthDetailCell
                    cell.movieID = movie?.id
                    return cell
                }
                else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FifthCellId", for: indexPath) as! FifthDetailCell
                    cell.movie = movie
                    cell.navigationController = self.navigationController
                    return cell
                }
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThirdCellId", for: indexPath) as! ThirdDetailCell
                cell.plotTextView.text = plot
                return cell
            }
        }
        
        if indexPath.row == 3{
            if plot == nil || plot?.count == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FifthCellId", for: indexPath) as! FifthDetailCell
                cell.movie = movie
                cell.navigationController = self.navigationController
                return cell
            }
            else{
                if cast != nil{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FourthCellId", for: indexPath) as! FourthDetailCell
                    cell.movieID = movie?.id
                    return cell
                }
                else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FifthCellId", for: indexPath) as! FifthDetailCell
                    cell.movie = movie
                    cell.navigationController = self.navigationController
                    return cell
                }
            }
        }
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FifthCellId", for: indexPath) as! FifthDetailCell
        cell.movie = movie
        cell.navigationController = self.navigationController
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if animatedCells[indexPath.item] == .Animated{
            return
        }

        animatedCells[indexPath.item] = .Animated
        
        cell.frame.origin.y -= 40
        cell.layer.zPosition = 2
        cell.frame.origin.x =  -cell.frame.width
        let initialDelay = 0.3
        var delay = initialDelay + 0.2 * Double(indexPath.item)
        
        let numberOfLines = CGFloat(CGFloat(plot?.count ?? 0) / 53.0)
        if (numberOfLines >= 3.5 && indexPath.item > 2) || (indexPath.item == 4 || (indexPath.item == 3 && (plot == nil || plot?.count == 0))) {
            delay -= 1
        }
       
        UIView.animate(withDuration: 0.4, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
            cell.frame.origin.x = 0
        }) { (_) in
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let height: CGFloat =  60
        
        if indexPath.row == 0{
            return CGSize(width: width, height: height * 2 + 30)
        }
        
        if indexPath.row == 1{
                return CGSize(width: width, height: 100)
        }
        
        if indexPath.row == 2{
            if plot == nil || plot?.count == 0{
                if cast != nil{
                    return CGSize(width: width, height: 200)
                }
                else{
                    return CGSize(width: width, height: 270)
                }
            }
            else{
                let numberOfLines = CGFloat(CGFloat(plot?.count ?? 0) / 53.0)
                let constant: CGFloat = 70.0
                let plotHeight: CGFloat = constant + CGFloat(numberOfLines * 14)
                return CGSize(width: width, height: plotHeight)
            }
        }
        
        if indexPath.row == 3{
            if plot == nil || plot?.count == 0{
                return CGSize(width: width, height: 270)
            }
            else{
                if cast != nil{
                    return CGSize(width: width, height: 200)
                }
                else{
                    return CGSize(width: width, height: 270)
                }
            }
        }
        
        if indexPath.row == 4{
            return CGSize(width: width, height: 270)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    
    // navBar view
    let navBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor(white: 0, alpha: 0.6)
        return bar
    }()
    
    // navBar left button
    let navBarLeftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Back"), for: .normal)
        return button
    }()
    
    // navBar title
    let navBarTitle: UILabel = {
        let title = UILabel()
        title.text = "Featured"
        title.font = UIFont(name: "HelveticaNeue", size: 20)
        title.textColor = .white
        title.textAlignment = .center
        return title
    }()
    
}

extension MovieDetails: WatchTrailerDelegate{
    func playTrailer(url: URL) {
        let videoController = VideoViewController(url: url)
        navigationController?.pushViewController(videoController, animated: true)
    }
}
