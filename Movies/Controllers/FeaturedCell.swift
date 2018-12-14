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
    
    let imageView: UIImageView = {
        let image = UIImage(named: "maze")
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Maze Runner: Death Cure", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 12)])
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
