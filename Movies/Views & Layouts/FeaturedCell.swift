//
//  FeaturedCell.swift
//  Movies
//
//  Created by Raul Mena on 12/12/18.
//  Copyright © 2018 Raul Mena. All rights reserved.
//

import UIKit
import SDWebImage

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
    
    private func downloadImage(){
        if let path = movie?.poster_path{
            let posterStringURL = "https://image.tmdb.org/t/p/w500/\(path)"
            let posterURL = URL(string: posterStringURL)
            imageView.sd_setImage(with: posterURL) { (image, error, cache, url) in
                if let error = error{
                    print("Error downloading image: \(error.localizedDescription)")
                }
            }
        }
        else{
            self.imageView.image = UIImage(named: "picture_rect_white")
        }
    }
        
    var movie: Movie?{
        didSet{
            downloadImage()
            nameLabel.text = movie?.title
        }
    }
    
    var cast: [Cast]?
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "picture_rect_white"))
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
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
