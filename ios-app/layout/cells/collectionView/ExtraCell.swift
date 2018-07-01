//
//  ExtraCell.swift
//  Hausa
//
//  Created by Emre Can Bolat on 29.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

class ExtraCell: MainCell {

    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageOne.roundCorners([.topLeft], radius: 6)
        imageTwo.roundCorners([.topRight], radius: 6)
        self.roundCorners([.bottomLeft, .bottomRight], radius: 6)
    }
    
    var entries: ([Entry?], Int)? {
        
        didSet {
            
            self.imageOne.image = nil
            self.imageTwo.image = nil
            
            OperationQueue().addOperation(BlockOperation { () -> Void in

                if let first = self.entries?.0[(self.entries?.1)!] {
                    first.imageList.first?.setMedia()
                    OperationQueue.main.addOperation({ self.imageOne.image = first.imageList.first?.media })
                }
                
                if let second = self.entries?.0[(self.entries?.1)! + 1] {
                    second.imageList.first?.setMedia()
                    OperationQueue.main.addOperation({ self.imageTwo.image = second.imageList.first?.media })
                }
            })
        }
    }
    
    override func setColor(_ color: UIColor? = nil, type: ThemeType? = .main) {
        if color == nil {
            var colorToSet: UIColor
            switch type! {
            case .popular:
                colorToSet = UIColor.uiColorFromHex(rgbValue: UserConfig.getMostPopularColor()); break
            case .recentViews:
                colorToSet = UIColor.uiColorFromHex(rgbValue: UserConfig.getRecentViewsColor()); break
            case .recentSearches:
                colorToSet = UIColor.uiColorFromHex(rgbValue: UserConfig.getRecentSearchesColor()); break
            default:
                colorToSet = UIColor.uiColorFromHex(rgbValue: UserConfig.getMainThemeColor()); break
            }
            
            self.containerView.backgroundColor = colorToSet
        }
        else { self.containerView.backgroundColor = color }
    }
}
