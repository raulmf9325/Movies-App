//
//  FirstDetailCell.swift
//  Movies
//
//  Created by Raul Mena on 12/31/18.
//  Copyright © 2018 Raul Mena. All rights reserved.   
//

import UIKit

class FirstDetailCell: UICollectionViewCell{
    
    var movieID: Int?{
        didSet{
            Service.shared.fetchMovieDuration(movieID: movieID!) { (duration) in
                if let runtime = duration{
                    let hours = runtime / 60
                    let minutes = runtime % 60
                    self.durationLabel.text = "\(hours)h \(minutes)min"
                }
            }
        }
    }
    
    var posterURL: URL?{
        didSet{
            guard let url = posterURL else {return}
            imageView.sd_setImage(with: url) { (image, error, cache, url) in
                print("Error downloading image: \(error?.localizedDescription)")
            }
        }
    }
    
    var movieRating: Double?{
        didSet{
            guard let rating = movieRating else {return}
            ratingLabel.text = "rating: \(rating * 10)%"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews(){
        addSubview(imageView)
        addSubview(movieNameLabel)
        addSubview(durationLabel)
        addSubview(ratingLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0(80)]-20-[v1]|", views: imageView, movieNameLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0(80)]-20-[v1]", views: imageView, durationLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0(80)]-20-[v1]", views: imageView, ratingLabel)
        addConstraintsWithFormat(format: "V:[v0(120)]-30-|", views: imageView)
        addConstraintsWithFormat(format: "V:[v0]-55-|", views: durationLabel)
        addConstraintsWithFormat(format: "V:[v0]-4-[v1]", views: movieNameLabel, durationLabel)
        addConstraintsWithFormat(format: "V:[v0]-4-[v1]", views: durationLabel, ratingLabel)
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.backgroundColor = .lightGray
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowRadius = 8
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let movieNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
        return label
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .darkGray
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .darkGray
        label.text = "rating: "
        return label
    }()
}
