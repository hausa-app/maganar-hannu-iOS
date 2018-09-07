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
    @IBOutlet weak var imageThree: UIImageView!
    @IBOutlet weak var imageFour: UIImageView!
    
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
            self.imageThree.image = nil
            self.imageFour.image = nil
            
            OperationQueue().addOperation(BlockOperation { () -> Void in
                var first_entry: Entry!
                var second_entry: Entry!
                
                if let first = self.entries?.0[(self.entries?.1)!] {
                    first_entry = first
                    first.imageList.first?.setMedia()
                    OperationQueue.main.addOperation({ self.imageOne.image = first.imageList.first?.media })
                }
                
                if let second = self.entries?.0[(self.entries?.1)! + 1] {
                    second_entry = second
                    second.imageList.first?.setMedia()
                    OperationQueue.main.addOperation({ self.imageTwo.image = second.imageList.first?.media })
                }
                
                if (self.entries?.0.count)! >= ((self.entries?.1)! + 3), let third = self.entries?.0[(self.entries?.1)! + 2] {
                    third.imageList.first?.setMedia()
                    OperationQueue.main.addOperation({ self.imageThree.image = third.imageList.first?.media })
                } else {
                    OperationQueue.main.addOperation({ self.imageThree.image = second_entry.imageList.first?.media })
                }
                
                if (self.entries?.0.count)! >= ((self.entries?.1)! + 4), let fourth = self.entries?.0[(self.entries?.1)! + 3] {
                    fourth.imageList.first?.setMedia()
                    OperationQueue.main.addOperation({ self.imageFour.image = fourth.imageList.first?.media })
                } else {
                    OperationQueue.main.addOperation({ self.imageFour.image = first_entry.imageList.first?.media })
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
