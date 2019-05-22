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
    var posterImageURL: URL?{
        didSet{
            guard let url = posterImageURL else {return}
            headerImage.sd_setImage(with: url) { (image, error, cache, url) in
                if let error = error{
                    print("ERROR: \(error.localizedDescription)")
                }
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
        addSubview(headerImage)
        addConstraintsWithFormat(format: "H:|[v0]|", views: headerImage)
        addConstraintsWithFormat(format: "V:|[v0]|", views: headerImage)
    }
    
    let headerImage: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
}
