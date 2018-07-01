//
//  SplashViewController.swift
//  Hausa
//
//  Created by Emre Can Bolat on 31.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

open class SplashViewController: UIViewController {
    open var pulsing: Bool = false
    
    let animatedLogo = AnimatedLogo(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    var tileGridView: TileGridView!
    
    public init(tileViewFileName: String) {
        
        super.init(nibName: nil, bundle: nil)
        tileGridView = TileGridView(TileFileName: tileViewFileName)
        view.addSubview(tileGridView)
        tileGridView.frame = view.bounds
        
        view.addSubview(animatedLogo)
        animatedLogo.layer.position = view.layer.position
        animatedLogo.layer.position.y -= 150
        
        tileGridView.startAnimating()
        animatedLogo.startAnimating()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var prefersStatusBarHidden : Bool {
        return true
    }
}
