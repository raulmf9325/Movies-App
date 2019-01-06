//
//  FifthDetailCell.swift
//  Movies
//
//  Created by Raul Mena on 1/3/19.
//  Copyright © 2019 Raul Mena. All rights reserved.
//

import UIKit

class FifthDetailCell: UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setupViews(){
        
        addSubview(similarMoviesLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0]", views: similarMoviesLabel)
        addConstraintsWithFormat(format: "V:|-20-[v0]", views: similarMoviesLabel)
        
        addSubview(collection)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collection)
        addConstraintsWithFormat(format: "V:[v0]-4-[v1]|", views: similarMoviesLabel, collection)
        collection.delegate = self
        collection.dataSource = self
        collection.register(SimilarMovieCell.self, forCellWithReuseIdentifier: "CellId")
    }
    
    let similarMoviesLabel: UILabel = {
        let label = UILabel()
        label.text = "Similar Movies"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        return collection
    }()
    
}

extension FifthDetailCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! SimilarMovieCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 100
        let height = 180
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

class SimilarMovieCell: UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews(){
        addSubview(similarMovieImage)
        addConstraintsWithFormat(format: "H:|[v0]|", views: similarMovieImage)
        addConstraintsWithFormat(format: "V:|[v0(120)]", views: similarMovieImage)
        
        addSubview(similarMovieName)
        addConstraintsWithFormat(format: "H:|[v0]|", views: similarMovieName)
        addConstraintsWithFormat(format: "V:[v0]-6-[v1]", views: similarMovieImage, similarMovieName)
        
        addSubview(similarMovieRating)
        addConstraintsWithFormat(format: "H:|[v0]|", views: similarMovieRating)
        addConstraintsWithFormat(format: "V:[v0]-3-[v1]", views: similarMovieName, similarMovieRating)
    }
    
    let similarMovieImage: UIImageView = {
        let image = UIImage(named: "insurgent")
        let imageView = UIImageView(image: image)
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowRadius = 4
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        return imageView
    }()
    
    let similarMovieName: UILabel = {
        let label = UILabel()
        label.text = "Insurgent"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    let similarMovieRating: UILabel = {
        let label = UILabel()
        label.text = "42%"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
}
