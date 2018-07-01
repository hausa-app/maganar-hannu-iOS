//
//  FilterUIButton.swift
//  Hausa
//
//  Created by Emre Can Bolat on 03.01.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import UIKit

class FilterUIButton: UIButton {
    
    var type: FilterType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let text = self.titleLabel?.text
        
        if text == "Hausa" {
            self.type = .hausa
        } else if text == "English" {
            self.type = .english
        } else {
            self.type = .both
        }
        update()
    }
    
    func update() {
        if self.type == UserConfig.getFilterType() {
            self.imageView?.image = #imageLiteral(resourceName: "checked")
        }
    }
    
    override var isSelected: Bool {
        
        didSet {
            if isSelected == true {
                self.imageView?.isHidden = false
            } else {
                self.imageView?.isHidden = true
            }
        }
    }
    
}
