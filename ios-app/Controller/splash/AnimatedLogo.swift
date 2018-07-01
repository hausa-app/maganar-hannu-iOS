//
//  AnimatedLogo.swift
//  Hausa
//
//  Created by Emre Can Bolat on 31.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

open class AnimatedLogo: UIView {
    
    fileprivate let strokeEndTimingFunction = CAMediaTimingFunction(controlPoints: 1.00, 0.0, 0.35, 1.0)
    fileprivate let circleLayerTimingFunction = CAMediaTimingFunction(controlPoints: 0.65, 0.0, 0.40, 1.0)
    
    fileprivate let radius: CGFloat = 110
    fileprivate let startTimeOffset = 0.7 * kAnimationDuration
    
    fileprivate var circleLayer: CAShapeLayer!
    fileprivate var logoLayer: CAShapeLayer!
    
    var beginTime: CFTimeInterval = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        circleLayer = generateCircleLayer()
        logoLayer = generateLogoLayer()

        layer.addSublayer(circleLayer)
        layer.addSublayer(logoLayer)
    }
    
    open func startAnimating() {
        beginTime = CACurrentMediaTime()
        layer.anchorPoint = CGPoint.zero
    
        animateCircleLayer()
        animateLogoLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension AnimatedLogo {
    
    fileprivate func generateCircleLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineWidth = radius
        layer.path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius/2, startAngle: -CGFloat(Double.pi/2), endAngle: CGFloat(3 * Double.pi/2), clockwise: true).cgPath
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(generateLineLayer(-radius, 0 ,radius, 0))
        layer.addSublayer(generateLineLayer(0, -radius, 0, radius))
        layer.addSublayer(generateLineLayer(radius * cos(315.degreesToRadians), radius * sin(315.degreesToRadians),radius * cos(135.degreesToRadians), radius * sin(135.degreesToRadians)))
        layer.addSublayer(generateLineLayer(radius * cos(45.degreesToRadians), radius * sin(45.degreesToRadians),radius * cos(225.degreesToRadians), radius * sin(225.degreesToRadians)))
        
        return layer
    }
    
    fileprivate func generateLogoLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        let imageLayer = CALayer()
        imageLayer.backgroundColor = UIColor.clear.cgColor
        imageLayer.bounds = CGRect(x: -radius, y: -radius, width: radius * 2.0, height: radius * 2.0)
        imageLayer.contents = #imageLiteral(resourceName: "logo").cgImage
        layer.addSublayer(imageLayer)
        
        return layer
    }
    
    fileprivate func generateLineLayer(_ startX: CGFloat, _ startY: CGFloat, _ x: CGFloat, _ y: CGFloat)->CAShapeLayer {
        let layer = CAShapeLayer()
        layer.position = CGPoint.zero
        layer.frame = CGRect.zero
        layer.allowsGroupOpacity = true
        layer.lineWidth = 20.0
        layer.strokeColor = UIColor.black.cgColor
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: startX, y: startY))
        bezierPath.addLine(to: CGPoint(x: x, y: y))
        layer.path = bezierPath.cgPath
        return layer
    }
}

extension AnimatedLogo {
    
    fileprivate func animateCircleLayer() {
        // strokeEnd
        let strokeEndAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.timingFunction = strokeEndTimingFunction
        strokeEndAnimation.duration = kAnimationDuration - kAnimationDurationDelay
        strokeEndAnimation.values = [0.0, 1.0]
        strokeEndAnimation.keyTimes = [0.0, 1.0]
        
        // transform
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.timingFunction = strokeEndTimingFunction
        transformAnimation.duration = kAnimationDuration - kAnimationDurationDelay
        
        var startingTransform = CATransform3DMakeRotation(-CGFloat(Double.pi/4), 0, 0, 1)
        startingTransform = CATransform3DScale(startingTransform, 0.5, 0.5, 1)
        transformAnimation.fromValue = NSValue(caTransform3D:startingTransform)
        transformAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))
        
        let transformAnimationLine = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        transformAnimationLine.timingFunctions = [strokeEndTimingFunction, circleLayerTimingFunction]
        transformAnimationLine.duration = kAnimationDuration
        transformAnimationLine.keyTimes = [0.0, ((kAnimationDuration - kAnimationDurationDelay) / kAnimationDuration) as NSNumber, 1.0]
        transformAnimationLine.values = [0, 2 * Double.pi];
        
        // Group
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [transformAnimationLine]
        groupAnimation.repeatCount = Float.infinity
        groupAnimation.duration = kAnimationDuration
        groupAnimation.beginTime = beginTime
        groupAnimation.timeOffset = startTimeOffset
        
        circleLayer.add(groupAnimation, forKey: "looping")
    }
    
    fileprivate func animateLogoLayer() {
        
        // transform
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.timingFunction = strokeEndTimingFunction
        transformAnimation.duration = kAnimationDuration - kAnimationDurationDelay
        
        let startingTransform = CATransform3DMakeScale(0.3, 0.3, 1)
        transformAnimation.fromValue = NSValue(caTransform3D:startingTransform)
        transformAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))
        
        // Group
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [transformAnimation]
        groupAnimation.duration = kAnimationDuration
        groupAnimation.beginTime = beginTime
        groupAnimation.timeOffset = startTimeOffset
        
        //logoLayer.add(groupAnimation, forKey: "looping")
    }
}
