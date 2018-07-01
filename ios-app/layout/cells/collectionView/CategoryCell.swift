//
//  CategoryCell.swift
//  Hausa
//
//  Created by Emre Can Bolat on 17.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

class CategoryCell: MainCell {
    @IBOutlet fileprivate weak var image: UIImageView!
    @IBOutlet fileprivate weak var caption: UILabel!
    @IBOutlet weak var triangle: TriangleView!
    
    var category: Category? {
        didSet {
            OperationQueue().addOperation(BlockOperation { () -> Void in
                self.category?.image.setMedia()
                OperationQueue.main.addOperation({
                    self.image.image =  self.category?.image.media
                })
            })

            if category?.category_hausa == "" {
                caption.text = category?.category_english
            } else { caption.text = category?.category_hausa }
        }
    }
    
    func setCategoryColor(_ colorHex: Int) {
        self.triangle.color = UIColor.uiColorFromHex(rgbValue: colorHex).cgColor
        self.triangle.setNeedsDisplay()
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
            
            self.textContainer.backgroundColor = colorToSet
        }
        else { self.textContainer.backgroundColor = color }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        self.triangle.color = nil
    }
    
}
