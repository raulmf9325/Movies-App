//
//  CountingLabel.swift
//  CADisplayLink
//
//  Created by Raul Mena on 1/2/19.
//  Copyright © 2019 Raul Mena. All rights reserved.
//

import UIKit

class CountingLabel{


    init(label: UILabel, fromValue: Double, toValue: Double, duration: Double){
        self.label = label
        startValue = fromValue
        endValue = toValue
        animationDuration = duration
        setupAnimation()
    }

    fileprivate func setupAnimation(){
        displayLink = CADisplayLink(target: self, selector: #selector(refreshUI))
        displayLink.add(to: .main, forMode: .default)
    }

    @objc fileprivate func refreshUI(){

        let elapsedTime = Date().timeIntervalSince(animationStartDate)
        let percentage = elapsedTime / animationDuration
        let currentValue = startValue + percentage * (endValue - startValue)
        let integerValue = Int(currentValue)

        if currentValue > endValue{
            let integerEndValue = Int(endValue)
            label.text = "\(integerEndValue)%"
            displayLink.remove(from: .main, forMode: .default)
        }
        else{
            label.text = "\(integerValue)%"
        }
    }
    
    var label: UILabel!
    var startValue: Double = 0
    var endValue: Double = 1000
    var animationDuration: Double = 2
    let animationStartDate = Date()
    var displayLink: CADisplayLink!
}
