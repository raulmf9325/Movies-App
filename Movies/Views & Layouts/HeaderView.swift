//
//  HeaderView.swift
//  Movies
//
//  Created by Raul Mena on 12/31/18.
//  Copyright © 2018 Raul Mena. All rights reserved.
//

import UIKit

class HeaderView: UICollectionViewCell {
    
    let navBarHeight: CGFloat = 75
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews(){
        addSubview(headerImage)
        addConstraintsWithFormat(format: "H:|[v0]|", views: headerImage)
        addConstraintsWithFormat(format: "V:|-\(navBarHeight)-[v0]|", views: headerImage)
    }
    
    let headerImage: UIImageView = {
        let image = UIImage(named: "stretchy_header")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
}
