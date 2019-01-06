//
//  FeaturedCell.swift
//  Movies
//
//  Created by Raul Mena on 12/12/18.
//  Copyright © 2018 Raul Mena. All rights reserved.
//

import UIKit

// MARK: Featured Controller Cell
class BaseFeaturedCell: UICollectionViewCell{
    
    // Constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Set Up Views
    func setupViews(){
        
    }
    
    func downloadImage(){
        
        if let path = movie?.poster_path{
            let stringURL = "https://image.tmdb.org/t/p/w500/\(path)"
            
            if let image = BaseFeaturedCell.cache.object(forKey: stringURL as AnyObject) as? UIImage{
                imageView.image = image
                return
            }
            
            guard let url = URL(string: stringURL) else {return}
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil{ (error)
                    return
                }
                
                if let data = data{
                    if let image = UIImage(data: data){
                        DispatchQueue.main.async(execute: {
                            self.imageView.image = image
                            BaseFeaturedCell.cache.setObject(image, forKey: stringURL as AnyObject)
                           // print("downloading")
                        })
                    }
                }
                }.resume()
        }
        
    }
    
    static var cache = NSCache<AnyObject, AnyObject>()
    
    var movie: Movie?{
        didSet{
            downloadImage()
            nameLabel.text = movie?.title
        }
    }
    
    let imageView: UIImageView = {
        let image = UIImage(named: "header")
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Maze Runner: The Death Cure"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
} // END: Base Featured Cell


class IconFeaturedCell: BaseFeaturedCell{
    
    override func setupViews() {
        addSubview(imageView)
        addSubview(nameLabel)
        
        let labelHeight: CGFloat = 35
        let imageHeight = 110
        addConstraintsWithFormat(format: "V:|-8-[v0(\(imageHeight))]-4-[v1(\(labelHeight))]", views: imageView, nameLabel)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: imageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: nameLabel)
    }

} // END:  Icon Featured Cell

class GridFeaturedCell: BaseFeaturedCell{
    override func setupViews() {
        addSubview(imageView)
        addSubview(nameLabel)
        
        let labelHeight: CGFloat = 35
        let imageHeight = 205
        addConstraintsWithFormat(format: "V:|-8-[v0(\(imageHeight))]-4-[v1(\(labelHeight))]", views: imageView, nameLabel)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: imageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: nameLabel)
    }
}  // END:  Grid Featured Cell
