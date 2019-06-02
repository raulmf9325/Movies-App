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
        addConstraintsWithFormat(format: "V:|[v0]|", views: headerImage)
        addSubview(headerMask)
        addConstraintsWithFormat(format: "H:|[v0]|", views: headerMask)
        addConstraintsWithFormat(format: "V:|[v0]|", views: headerMask)
        dismissMask()
    }
    
    private func dismissMask(){
        UIView.animate(withDuration: 0.3, animations: {
            self.headerMask.alpha = 0
        }) { (_) in
            self.headerMask.removeFromSuperview()
        }
    }
    
    let headerMask: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let headerImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "picture"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
}
