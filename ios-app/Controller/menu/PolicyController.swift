//
//  PolicyController.swift
//  Hausa
//
//  Created by Emre Can Bolat on 09.09.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import UIKit

class PolicyController: UIViewController {
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var navBAR: UINavigationBar!
    
    var interactor: Interactor? = nil
    
    let logoImage = #imageLiteral(resourceName: "logo-black")
    
    override func viewDidLoad() {
        if let bar = navBAR {
            let width = bar.frame.size.width
            let height = bar.frame.size.height
            let x = width / 2 - logoImage.size.width / 2
            let y = height / 2 - logoImage.size.height / 2
            
            let imageView = UIImageView(image: logoImage)
            imageView.frame = CGRect(x: x, y: y, width: width, height: height)
            imageView.contentMode = .scaleAspectFit
            navItem.titleView = imageView
        }
    }
    
    @IBAction func exitScreen(_ sender: UIBarButtonItem) {
        interactor?.toView = "menu"
        self.dismiss(animated: true)
    }
}
