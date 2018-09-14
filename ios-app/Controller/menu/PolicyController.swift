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
            let height = bar.frame.size.height
            
            let imageView = UIImageView(image: logoImage)
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: (height / logoImage.size.height) * logoImage.size.width, height: height))
            imageView.frame = titleView.bounds
            titleView.addSubview(imageView)
            
            self.navItem.titleView = titleView
        }
    }
    
    @IBAction func exitScreen(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}
