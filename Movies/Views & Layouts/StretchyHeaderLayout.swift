//
//  StretchyHeaderLayout.swift
//  StretchyHeader
//
//  Created by Raul Mena on 12/25/18.
//  Copyright © 2018 Raul Mena. All rights reserved.
//

import UIKit

class StretchyHeaderLayout: UICollectionViewFlowLayout{
    // We want to modify the attributes of the CollectionView Header
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        layoutAttributes?.forEach({ (attributes) in
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader{
                
                guard let collectionView = collectionView else {return}
                let contentOffsetY = collectionView.contentOffset.y
                
                // if Scrolling Downwards Don't Modify attributes
                if contentOffsetY > 0{
                    return
                }
                
                let width = collectionView.frame.width
                let height = attributes.frame.height - contentOffsetY
                
                // header
                attributes.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
                
            }
        })
        
        return layoutAttributes
    }
    
    // 
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
