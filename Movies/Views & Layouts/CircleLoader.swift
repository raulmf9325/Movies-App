//
//  CircleLoader.swift
//  Movies
//
//  Created by Raul Mena on 1/1/19.
//  Copyright © 2019 Raul Mena. All rights reserved.
//

import UIKit

class CircleLoader{
    
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    var view: UIView!
    var centerPoint: CGPoint!
    var value: Double!
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    init(containerView: UIView, centerPoint: CGPoint, value: Double){
        self.view = containerView
        self.centerPoint = centerPoint
        self.value = value
        setupCircleLayers()
        setupPercentageLabel()
        animateCircle()
    }
    
    fileprivate func setupPercentageLabel(){
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 13, y: 0, width: 100, height: 100)
        percentageLabel.center = centerPoint
    }
    
    fileprivate func setupCircleLayers(){
        
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .clear)
        view.layer.addSublayer(trackLayer)
        
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    fileprivate func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer{
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 30, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 10
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.position = centerPoint
        return layer
    }
    
    fileprivate func animateCircle() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = value / 100
        animation.duration = 2
        animation.isRemovedOnCompletion = false
        
        animation.fillMode = .forwards
        shapeLayer.add(animation, forKey: "CircleLoader")
        CountingLabel(label: percentageLabel, fromValue: 0, toValue: value, duration: 2)
    }
    
}
