//
//  ViewExtension.swift
//  Movies
//
//  Created by Raul Mena on 12/10/18.
//  Copyright © 2018 Raul Mena. All rights reserved.
//

import UIKit

// MARK: extension for UIView
// Activate Auto Layout
extension UIView{
    func addConstraintsWithFormat(format : String, views : UIView...){
        var viewsDictionary = [String : AnyObject]()
        for(index, view) in views.enumerated(){
            view.translatesAutoresizingMaskIntoConstraints = false
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
