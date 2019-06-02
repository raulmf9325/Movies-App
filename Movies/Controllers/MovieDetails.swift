//
//  MovieDetails.swift
//  Movies
//
//  Created by Raul Mena on 12/14/18.
//  Copyright © 2018 Raul Mena. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

// MARK: MovieDetails Class
class MovieDetails: UICollectionViewController{
    
    var navigationDelegate: NavigationDelegate!
    var activityIndicator: NVActivityIndicatorView!
    
    var numberOfItemsInSection = 0
    
    var downloadComplete = false
    var backdropComplete = false
    var posterComplete = false
    var castComplete = false
    var genresComplete = false
    var durationComplete = false
    var trailerComplete = false
    var similarMoviesComplete = false
    
    var movie: Movie?{
        didSet{
            fetchContent()
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
        startActivityIndicator()
        setupCollectionView()
        setupNavigationBar()
        setupScreenEdgeSwipe()
    }
    
    fileprivate func startActivityIndicator() {
        if downloadComplete{ return }
        view.addSubview(activityIndicatorContainer)
        activityIndicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorContainer.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        activityIndicatorContainer.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
        activityIndicatorContainer.widthAnchor.constraint(equalToConstant: 80).isActive = true
        activityIndicatorContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80), type: .circleStrokeSpin, color: .white, padding: 17)
        activityIndicatorContainer.addSubview(activityIndicator)
        activityIndicator.startAnimating()
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
    
    fileprivate func fetchContent() {
        
        let movieID = movie!.id!
        
        // fetch poster
        if let path = movie?.poster_path{
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/\(path)")
            poster.sd_setImage(with: imageURL) { (image, error, cache, url) in
                self.posterComplete = true
                self.checkDownload()
            }
        }
        else{
            self.posterComplete = true
            self.checkDownload()
        }
        
        // fetch backdrop
        if let headerPosterPath = movie?.backdrop_path{
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w1280/\(headerPosterPath)")
            backdrop.sd_setImage(with: imageURL) { (image, error, cache, url) in
                self.backdropComplete = true
                self.checkDownload()
            }
        }
        else{
            if self.poster.image != UIImage(named: "picture_rect_white"){
                self.backdrop.image = self.poster.image
            }
            self.backdropComplete = true
            self.checkDownload()
        }
        
        // fetch duration
        Service.shared.fetchMovieDuration(movieID: movieID) { (duration) in
            self.durationComplete = true
            if let runtime = duration{
                let hours = runtime / 60
                let minutes = runtime % 60
                self.duration = "\(hours)h \(minutes)min"
            }
            self.checkDownload()
        }
        
        // fetch genres
        Service.shared.fetchMovieGenres(movieID: movieID) { (genres) in
            self.genresComplete = true
            self.checkDownload()
            guard let genres = genres else {return}
            if genres.count > 0{
                var genre = ""
                for i in 0 ..< genres.count{
                    if i < 5{
                        if let name = genres[i].name{
                            genre.append(contentsOf: name)
                            if i < genres.count - 1 && i < 4{
                                genre += ", "
                            }
                            else{
                                genre += " "
                            }
                        }
                    }
                }
                self.genres += genre
            }
            else{
                self.genres += "not available"
            }
        }
        
        // fetch trailer URL
        Service.shared.fetchMovieTrailerURL(movieID: movieID) { (trailers) in
            self.trailerComplete = true
            self.checkDownload()
            guard let trailers = trailers else {return}
            if trailers.count > 0{
                if let key = trailers[0].key{
                    self.videoURL = URL(string: "https://www.youtube.com/embed/\(key)")
                }
            }
        }
        
        // fetch cast
        Service.shared.fetchMovieCast(movieID: movieID) { (movieCast) in
            guard let casting = movieCast else {
                self.castComplete = true
                self.checkDownload()
                return
            }
            var tmp = [Cast]()
            for (_, profile) in casting.enumerated(){
                if profile.name != nil{
                    tmp.append(profile)
                }
            }
            if casting.count > 0{
                self.cast = tmp
            }
            self.castComplete = true
            self.checkDownload()
        }
        
        // fetch similar movies
        if let genres = movie?.genre_ids{
            var genreString = ""
            for index in 0 ... 2{
                if index + 1 <= genres.count{
                    genreString.append(contentsOf: "\(genres[index]),")
                }
            }
            
            Service.shared.fetchMoviesWithGenres(genres: genreString) { (similarMovies) in
                var similar = [Movie]()
                for similarMovie in similarMovies{
                    if similarMovie.title != self.movie?.title{
                        similar.append(similarMovie)
                    }
                }
                self.similarMovies = similar
                self.similarMoviesComplete = true
                self.checkDownload()
            }
        }
        else{
            self.similarMoviesComplete = true
            self.checkDownload()
        }
        
        // fetch name, rating, duration, release date and plot
        movieName = movie?.title
        movieRating = movie?.vote_average
        releaseDate = movie?.release_date
        plot = movie?.overview
    }
    
    fileprivate func checkDownload(){
        downloadComplete = true
        
        [backdropComplete, posterComplete, castComplete, genresComplete,
         durationComplete, trailerComplete, similarMoviesComplete].forEach { (itemComplete) in
            if !itemComplete{
                downloadComplete = false
            }
        }
        
        if downloadComplete{
            numberOfItemsInSection = 3
            
            if plot != nil && ((plot?.count ?? 0) > 0){
                numberOfItemsInSection += 1
            }
            else{
                print("empty plot")
            }
            
            if cast != nil{
                numberOfItemsInSection += 1
            }
            else{
                print("empty cast")
            }
            
            if activityIndicator == nil{
                collectionView.reloadData()
            }
            else{
                UIView.animate(withDuration: 0.3, animations: {
                     self.activityIndicatorContainer.alpha = 0
                     self.activityIndicator.alpha = 0
                }) { (_) in
                    self.activityIndicator.stopAnimating()
                    self.activityIndicatorContainer.removeFromSuperview()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    /*  Stored Properties
     */
    
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
    
    // activity indicator container
    let activityIndicatorContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 12
        return view
    }()
    
    // backdrop
    let backdrop: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "picture"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // poster
    let poster: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "picture_rect_white"))
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowRadius = 8
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var movieName: String?
    var moviePosterURL: URL?
    var headerPosterURL: URL?
    var movieRating: Double?
    var releaseDate: String?
    var plot: String?
    var cast: [Cast]?
    
    var duration = ""
    var genres = "Genre: "
    var videoURL: URL?
    
    var similarMovies = [Movie]()
}

/*  Collection View methods
 */

extension MovieDetails: UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
            header.headerImage.image = backdrop.image
            return header
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        animatedCells.append(animationState.notAnimated)
        
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstCellId", for: indexPath) as! FirstDetailCell
            cell.movieNameLabel.text = movieName
            cell.imageView.image = poster.image
            cell.movieRating = movieRating
            cell.durationLabel.text = duration
            return cell
        }
        
        if indexPath.row == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondCellId", for: indexPath) as! SecondDetailCell
            cell.releaseDate.text = releaseDate
            cell.genreLabel.text = genres
            cell.videoURL = videoURL
            cell.trailerDelegate = self
            return cell
        }
        
        if indexPath.row == 2{
            if plot == nil || plot?.count == 0{
                if cast != nil{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FourthCellId", for: indexPath) as! FourthDetailCell
                    cell.cast = cast
                    return cell
                }
                else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FifthCellId", for: indexPath) as! FifthDetailCell
                    cell.similar = similarMovies
                    cell.navigationDelegate = navigationDelegate
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
                cell.similar = similarMovies
                cell.navigationDelegate = navigationDelegate
                return cell
            }
            else if cast != nil{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FourthCellId", for: indexPath) as! FourthDetailCell
                cell.cast = cast
                return cell
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FifthCellId", for: indexPath) as! FifthDetailCell
                cell.similar = similarMovies
                cell.navigationDelegate = navigationDelegate
                return cell
            }
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FifthCellId", for: indexPath) as! FifthDetailCell
        cell.similar = similarMovies
        cell.navigationDelegate = navigationDelegate
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
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0
            
            if cell.frame.origin.y > view.frame.height - bottomPadding{
                delay -= 1
            }
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
}


extension MovieDetails: WatchTrailerDelegate{
    func playTrailer(url: URL) {
        let videoController = VideoViewController(url: url)
        navigationController?.pushViewController(videoController, animated: true)
    }
}
