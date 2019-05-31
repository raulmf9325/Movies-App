//
//  LoadingPage.swift
//  Movies
//
//  Created by Raul Mena on 5/30/19.
//  Copyright © 2019 Raul Mena. All rights reserved.
//

import UIKit

class LoadingPage: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(loadingImage)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: loadingImage)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: loadingImage)
    }
    
    func dismiss(){
        dismiss(animated: false, completion: nil)
    }
    
    
    let loadingImage: UIImageView = {
        let image = UIImage(named: "collage")
        let imageView = UIImageView(image: image)
        return imageView
    }()
}
