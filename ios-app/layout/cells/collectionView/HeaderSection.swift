//
//  HeaderSection.swift
//  Hausa
//
//  Created by Emre Can Bolat on 19.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

class HeaderSection: UICollectionReusableView {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textContainer: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    
    var settingsActive = false
    
    let settingsImage = #imageLiteral(resourceName: "settings_ico")
    let exitImage = #imageLiteral(resourceName: "home")
    
    var settingsHandler: () -> () = { }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if settingsButton != nil {
            settingsButton.isSelected = false
        }
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
            
            if textContainer == nil {
                self.backgroundColor = colorToSet
            } else { self.textContainer.backgroundColor = colorToSet }
            
        }
        else {
            if textContainer == nil {
                self.backgroundColor = color
            } else {
                self.textContainer.backgroundColor = color
            }
            
        }
    }
    
    func setHeader(_ text: String, withButton: Bool? = false) {
        headerLabel.text = text
        if settingsButton == nil { return }
        if withButton! {
            settingsButton.isHidden = false
        } else {
            settingsButton.isHidden = true
        }
    }

    @IBAction func requestSettings(_ sender: UIButton) {
        settingsHandler()
    }
    
    func changeIcon(_ settings: Bool) {
        settingsActive = settings
        settingsButton.isSelected = settings
    }
}
