//
//  FirstDetailCell.swift
//  Movies
//
//  Created by Raul Mena on 12/31/18.
//  Copyright © 2018 Raul Mena. All rights reserved.   
//

import UIKit

class FirstDetailCell: UICollectionViewCell{
    
    var movieRating: Double?{
        didSet{
            let circleRadius: CGFloat = 50
            addSubview(circleFrame)
            addConstraintsWithFormat(format: "H:|-16-[v0(\(circleRadius * 2))]", views: circleFrame)
            addConstraintsWithFormat(format: "V:[v0(\(circleRadius * 2))]|", views: circleFrame)

            
            let circleBar = CircleLoader(containerView: self, centerPoint: CGPoint(x: 100 + circleRadius, y: 90 + circleRadius), value: movieRating! * 10)
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
       
        // whiteView
        addSubview(whiteView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: whiteView)
        let separation = frame.height / 2 + 20
        addConstraintsWithFormat(format: "V:[v0(\(separation))]|", views: whiteView)
        
        addSubview(imageView)
        addSubview(movieNameLabel)
        addSubview(durationLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0(80)]-20-[v1]|", views: imageView, movieNameLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0(80)]-20-[v1]", views: imageView, durationLabel)
        addConstraintsWithFormat(format: "V:[v0(120)]-30-|", views: imageView)
        addConstraintsWithFormat(format: "V:[v0]-55-|", views: durationLabel)
        addConstraintsWithFormat(format: "V:[v0]-4-[v1]", views: movieNameLabel, durationLabel)
        
    }
    
    
    let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let imageView: UIImageView = {
        let image = UIImage(named: "maze")
        let imageView = UIImageView(image: image)
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowRadius = 8
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let movieNameLabel: UILabel = {
        let label = UILabel()
        label.text = "The Maze Runner: Death Cure"
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
        return label
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.text = "2h 43min"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .darkGray
        return label
    }()
    
    let circleFrame: UIView = {
        let circle = UIView()
        return circle
    }()
}
