//
//  ThirdDetailCell.swift
//  Movies
//
//  Created by Raul Mena on 1/3/19.
//  Copyright © 2019 Raul Mena. All rights reserved.
//

import UIKit

class ThirdDetailCell: UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews(){
        addSubview(plotLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0]", views: plotLabel)
        addConstraintsWithFormat(format: "V:|-10-[v0]", views: plotLabel)
        
        addSubview(plotTextView)
        addConstraintsWithFormat(format: "H:|-12-[v0]-16-|", views: plotTextView)
        addConstraintsWithFormat(format: "V:[v0]-6-[v1]|", views: plotLabel, plotTextView)
        
    }
    
    let plotLabel: UILabel = {
        let label = UILabel()
        label.text = "Plot"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let plotTextView: UITextView = {
        let text = UITextView()
        text.text = "Thomas leads some escaped Gladers on their final and most dangerous mission yet. To save their friends, they must break into the legendary Last City, a WCKD-controlled labyrinth that may turn out to be the deadliest maze of all. Anyone who makes it out alive will get answers to the questions that the Gladers have been asking since they arrived in the maze."
        text.textColor = .lightGray
        text.font = UIFont.systemFont(ofSize: 12)
        text.isEditable = false
        text.isScrollEnabled = false
        return text
    }()
    
}
