//
//  TileGridView.swift
//  Hausa
//
//  Created by Emre Can Bolat on 31.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

class TileGridView: UIView {
    
    fileprivate var containerView: UIView!
    fileprivate var modelTileView: TileView!
    fileprivate var centerTileView: TileView? = nil
    fileprivate var numberOfRows = 0
    fileprivate var numberOfColumns = 0
    
    fileprivate var logoLabel: UIView!
    fileprivate var tileViewRows: [[TileView]] = []
    fileprivate var beginTime: CFTimeInterval = 0
    fileprivate let kRippleDelayMultiplier: TimeInterval = 0.0006666
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.center = center
        modelTileView.center = containerView.center
        //if let centerTileView = centerTileView {
            // Custom offset needed for UILabel font
            //let center = CGPoint(x: centerTileView.bounds.midX + 31, y: centerTileView.bounds.midY)
            //logoLabel.center = center
        //}
    }
    
    init(TileFileName: String) {
        modelTileView = TileView(TileFileName: TileFileName)
        super.init(frame: CGRect.zero)
        clipsToBounds = true
        layer.masksToBounds = true
        
        containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 630.0, height: 990.0))
        containerView.backgroundColor = UIColor.white
        containerView.clipsToBounds = false
        containerView.layer.masksToBounds = false
        addSubview(containerView)
        
        renderTileViews()
        
        layoutIfNeeded()
    }
    
    func startAnimating() {
        beginTime = CACurrentMediaTime()
        startAnimatingWithBeginTime(beginTime)
    }
}

extension TileGridView {
    
    fileprivate func generateLogoLabel() -> UIView {
        let view = UIView()

        let image = #imageLiteral(resourceName: "logo-font")
        let width: CGFloat = UIScreen.main.bounds.width * 0.8; let aspect =  width / image.size.width
        let height = aspect * image.size.height
        
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        logo.image = image
        logo.center = CGPoint(x: -25, y: 45)
        view.addSubview(logo)
        
        return view
    }
    
    fileprivate func renderTileViews() {
        let width = containerView.bounds.width
        let height = containerView.bounds.height
        
        let modelImageWidth = modelTileView.bounds.width
        let modelImageHeight = modelTileView.bounds.height
        
        numberOfColumns = Int(ceil((width - modelTileView.bounds.size.width / 2.0) / modelTileView.bounds.size.width))
        numberOfRows = Int(ceil((height - modelTileView.bounds.size.height / 2.0) / modelTileView.bounds.size.height))
        
        for y in 0..<numberOfRows {
            
            var tileRows: [TileView] = []
            for x in 0..<numberOfColumns {
                
                let view = TileView()
                view.frame = CGRect(x: CGFloat(x) * modelImageWidth, y:CGFloat(y) * modelImageHeight, width: modelImageWidth, height: modelImageHeight)
                
                if view.center == containerView.center {
                    centerTileView = view
                }
                
                containerView.addSubview(view)
                tileRows.append(view)
                
                if y != 0 && y != numberOfRows - 1 && x != 0 && x != numberOfColumns - 1 {
                    view.shouldEnableRipple = true
                }
            }
            
            tileViewRows.append(tileRows)
        }
        
        if let centerTileView = centerTileView {
            containerView.bringSubviewToFront(centerTileView)
        }
    }
    
    fileprivate func startAnimatingWithBeginTime(_ beginTime: TimeInterval) {
        
        let linearTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        let keyframe = CAKeyframeAnimation(keyPath: "transform.scale")
        keyframe.timingFunctions = [linearTimingFunction, CAMediaTimingFunction(controlPoints: 0.6, 0.0, 0.15, 1.0), linearTimingFunction]
        keyframe.repeatCount = Float.infinity;
        keyframe.duration = kAnimationDuration
        keyframe.isRemovedOnCompletion = false
        keyframe.keyTimes = [0.0, 0.45, 0.887, 1.0]
        keyframe.values = [0.75, 0.75, 1.0, 1.0]
        keyframe.beginTime = beginTime
        keyframe.timeOffset = kAnimationTimeOffset
        
        containerView.layer.add(keyframe, forKey: "scale")
        
        for tileRows in tileViewRows {
            for view in tileRows {
                
                let distance = distanceFromCenterViewWithView(view)
                var vector = normalizedVectorFromCenterViewToView(view)
                
                vector = CGPoint(x: vector.x * kRippleMagnitudeMultiplier * distance, y: vector.y * kRippleMagnitudeMultiplier * distance)
                
                view.startAnimatingWithDuration(kAnimationDuration, beginTime: beginTime, rippleDelay: kRippleDelayMultiplier * TimeInterval(distance), rippleOffset: vector)
            }
        }
    }
    
    fileprivate func distanceFromCenterViewWithView(_ view: UIView)->CGFloat {
        guard let centerTileView = centerTileView else { return 0.0 }
        
        let normalizedX = (view.center.x - centerTileView.center.x)
        let normalizedY = (view.center.y - centerTileView.center.y)
        return sqrt(normalizedX * normalizedX + normalizedY * normalizedY)
    }
    
    fileprivate func normalizedVectorFromCenterViewToView(_ view: UIView)->CGPoint {
        let length = distanceFromCenterViewWithView(view)
        guard let centerTileView = centerTileView , length != 0 else { return CGPoint.zero }
        
        let deltaX = view.center.x - centerTileView.center.x
        let deltaY = view.center.y - centerTileView.center.y
        return CGPoint(x: deltaX / length, y: deltaY / length)
    }
}
