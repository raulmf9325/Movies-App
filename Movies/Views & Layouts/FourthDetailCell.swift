//
//  FourthDetailCell.swift
//  Movies
//
//  Created by Raul Mena on 1/3/19.
//  Copyright © 2019 Raul Mena. All rights reserved.
//

import UIKit

class FourthDetailCell: UICollectionViewCell{
    
    var movieID: Int?{
        didSet{
            Service.shared.fetchMovieCast(movieID: movieID!) { (movieCast) in
                guard let casting = movieCast else {return}
                var tmp = [Cast]()
                for (index, profile) in casting.enumerated(){
                    if profile.name != nil{
                        tmp.append(profile)
                    }
                }
                self.cast = tmp
                self.collection.reloadData()
            }
        }
    }
    
    var cast: [Cast]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setupViews(){
        addSubview(castLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0]", views: castLabel)
        addConstraintsWithFormat(format: "V:|-10-[v0]", views: castLabel)
        
        addSubview(collection)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collection)
        addConstraintsWithFormat(format: "V:[v0]-4-[v1]|", views: castLabel, collection)
        collection.delegate = self
        collection.dataSource = self
        collection.register(CastCell.self, forCellWithReuseIdentifier: "CellId")
        
    }
    
    let castLabel: UILabel = {
        let label = UILabel()
        label.text = "Cast"
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

extension FourthDetailCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = cast?.count else {return 0}
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! CastCell
        cell.profile = cast?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 100
        let height = 160
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
}

class CastCell: UICollectionViewCell{
    
    var profile: Cast?{
        didSet{
            actorName.text = profile?.character
            actorRealName.text = profile?.name
            
            if profile?.profile_path != nil{
                downloadImage()
            }
            else{
                actorImage.image = UIImage(named: "Actor")
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
    
    fileprivate func setupViews(){
        
        addSubview(actorImage)
        addConstraintsWithFormat(format: "H:|[v0(100)]", views: actorImage)
        addConstraintsWithFormat(format: "V:|[v0(100)]", views: actorImage)
        
        addSubview(actorRealName)
        addConstraintsWithFormat(format: "H:|[v0]|", views: actorRealName)
        addConstraintsWithFormat(format: "V:[v0]-4-[v1]", views: actorImage, actorRealName)
        
        addSubview(actorName)
        addConstraintsWithFormat(format: "H:|[v0]|", views: actorName)
        addConstraintsWithFormat(format: "V:[v0]-4-[v1]", views: actorRealName, actorName)
    }
    
    func downloadImage(){
        
        if let path = profile?.profile_path{
            let stringURL = "https://image.tmdb.org/t/p/w300/\(path)"
            let actorImageURL = URL(string: stringURL)
            actorImage.sd_setImage(with: actorImageURL) { (image, error, cache, url) in }
        }
    }
    
    let actorImage: UIImageView = {
        let image = UIImage(named: "Actor")
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 100 / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var actorRealName: UILabel = {
        let label = UILabel()
        label.text = "Dylan O'Brien"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    var actorName: UILabel = {
        let label = UILabel()
        label.text = "Thomas"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
}
