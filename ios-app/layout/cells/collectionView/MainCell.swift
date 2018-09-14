//
//  CustomCollectionCell.swift
//  Hausa
//
//  Created by Emre Can Bolat on 10.01.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textContainer: UIView!
    @IBOutlet weak var delete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //containerView.layer.cornerRadius = 6
        //containerView.layer.masksToBounds = true
    }
    
    func setColor(_ color: UIColor? = nil, type: ThemeType? = .main) {
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
            
            self.textContainer.backgroundColor = colorToSet
        }
        else { self.textContainer.backgroundColor = color }
    }
    
    func isOldColor() -> Bool {
        if self.textContainer.backgroundColor == UIColor.uiColorFromHex(rgbValue: UserConfig.getMainThemeColor()) {
            return false
        }
        return true
    }
    
}
