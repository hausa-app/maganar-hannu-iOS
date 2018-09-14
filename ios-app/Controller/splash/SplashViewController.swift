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
    
    var tileGridView: TileGridView!
    
    public init(tileViewFileName: String) {
        
        super.init(nibName: nil, bundle: nil)
        tileGridView = TileGridView(TileFileName: tileViewFileName)
        view.addSubview(tileGridView)
        tileGridView.frame = view.bounds
        
        let animatedLogo =
            AnimatedLogo(frame: CGRect(x: self.view.frame.width * 0.5, y: self.view.frame.height * 0.5, width: self.view.frame.width * 0.75, height: self.view.frame.width * 0.75))
        
        view.addSubview(animatedLogo)
        animatedLogo.layer.position = view.layer.position
        
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
