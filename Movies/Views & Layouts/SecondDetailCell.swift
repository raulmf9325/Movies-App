//
//  SecondDetailCell.swift
//  Movies
//
//  Created by Raul Mena on 1/1/19.
//  Copyright © 2019 Raul Mena. All rights reserved.
//

import UIKit

protocol WatchTrailerDelegate{
    func playTrailer(url: URL)
}

class SecondDetailCell: UICollectionViewCell{
    
    var trailerDelegate: WatchTrailerDelegate?
    var videoURL: URL?{
        didSet{
            if videoURL == nil{
                handleNoTrailer()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func handleNoTrailer(){
        playButtonView.removeFromSuperview()
        watchTrailerLabel.removeFromSuperview()
    }
    
    fileprivate func setupViews(){
        addSubview(informationLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0]", views: informationLabel)
        addConstraintsWithFormat(format: "V:|[v0]", views: informationLabel)
        
        addSubview(releaseDateLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0]", views: releaseDateLabel)
        addConstraintsWithFormat(format: "V:[v0]-8-[v1]", views: informationLabel, releaseDateLabel)
        
        addSubview(releaseDate)
        addConstraintsWithFormat(format: "H:[v0]-4-[v1]", views: releaseDateLabel, releaseDate)
        addConstraintsWithFormat(format: "V:[v0]-8-[v1]", views: informationLabel, releaseDate)
        
        addSubview(genreLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0]", views: genreLabel)
        addConstraintsWithFormat(format: "V:[v0]-5-[v1]", views: releaseDateLabel, genreLabel)
        
        addSubview(genre)
        addConstraintsWithFormat(format: "H:[v0]-4-[v1]", views: genreLabel, genre)
        addConstraintsWithFormat(format: "V:[v0]-5-[v1]", views: releaseDateLabel, genre)
        
        addSubview(playButtonView)
        addConstraintsWithFormat(format: "H:|-16-[v0(20)]", views: playButtonView)
        addConstraintsWithFormat(format: "V:[v0]-8-[v1(20)]", views: genreLabel, playButtonView)
        
        addSubview(watchTrailerLabel)
        addConstraintsWithFormat(format: "H:[v0]-8-[v1]", views: playButtonView, watchTrailerLabel)
        addConstraintsWithFormat(format: "V:[v0]-8-[v1(20)]", views: genreLabel, watchTrailerLabel)
        
        [playButtonView, watchTrailerLabel].forEach { (view) in
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playTrailer)))
        }
    }
    
    @objc private func playTrailer(){
        guard let url = videoURL else {return}
        trailerDelegate?.playTrailer(url: url)
    }
    
    let informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Information"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Release Date:"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var releaseDate: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.text = "Genre:"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let genre: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let playButtonView: UIImageView = {
        let image = UIImage(named: "PlayButton")
        let imageView = UIImageView(image: image)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let watchTrailerLabel: UILabel = {
        let label = UILabel()
        label.text = "Watch Trailer"
        label.textColor = UIColor(red: 0.71, green: 0.02, blue: 0.02, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 13)
        label.isUserInteractionEnabled = true
        return label
    }()
}
