//
//  TextCheckCell.swift
//  Hausa
//
//  Created by Emre Can Bolat on 05.01.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import Foundation
import UIKit

class TextCheckCell: UITableViewCell {
    
    let checkedImage = UIImageView()
    let textView = UILabel()
    let seperator = UIView()
    
    var viewsDict: [String : Any]!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        checkedImage.image = #imageLiteral(resourceName: "checked")
        seperator.backgroundColor = UIColor.groupTableViewBackground
        
        checkedImage.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        seperator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(checkedImage)
        contentView.addSubview(textView)
        contentView.addSubview(seperator)
        
        viewsDict = [
            "checkedImage" : checkedImage,
            "textView" : textView,
            "seperator" : seperator,
            ] as [String : Any]

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[checkedImage(30)]", options: .alignAllCenterY, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[textView]-[checkedImage(30)]-30-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-[seperator]-|", options: [], metrics: nil, views: viewsDict))
        seperator.addConstraint(NSLayoutConstraint(item: seperator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
        contentView.addConstraint(NSLayoutConstraint(item: seperator, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: checkedImage, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: textView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 49))
        
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextAndCheck(text: String, check: Bool) {
        self.textView.text = text
        if check {
            self.checkedImage.isHidden = false
        } else {
            self.checkedImage.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = UIColor.groupTableViewBackground
        super.setSelected(selected, animated: animated)

        if(selected) {
            seperator.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = UIColor.groupTableViewBackground
        super.setHighlighted(highlighted, animated: animated)
        
        if(highlighted) {
            seperator.backgroundColor = color
        }
    }
}
