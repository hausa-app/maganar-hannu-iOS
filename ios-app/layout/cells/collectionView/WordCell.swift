//
//  WordCell.swift
//  Hausa
//
//  Created by Emre Can Bolat on 17.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

class WordCell: MainCell {
    
    let animationRotateDegres: CGFloat = 0.5
    let animationTranslateX: CGFloat = 1.0
    let animationTranslateY: CGFloat = 1.0
    let count: Int = 1
    
    @IBOutlet weak var hausaLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var settingsActive = false
    
    var deleteHandler: () -> () = { }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.delete != nil {
            self.delete.layer.cornerRadius = delete.frame.height/2
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if self.delete != nil {
            self.delete.isHidden = true
        }
    }
    
    var word: Entry? {
        didSet {
            
            if word is EnglishEntry {
                self.hausaLabel.text = getAsString(list: (word?.translationList)!)
                self.englishLabel.text = word?.word
            } else {
                self.hausaLabel.text = word?.word
                self.englishLabel.text = getAsString(list: (word?.translationList)!)
            }

            self.imageView.image = nil
            OperationQueue().addOperation(BlockOperation { () -> Void in
                self.word?.imageList.first?.setMedia()
                
                OperationQueue.main.addOperation({
                    self.imageView.image =  self.word?.imageList.first?.media
                })
            })
        }
    }
    
    public func getAsString(list: [String]) -> String {
        var string = ""
        for a in list {
            string.append(a)
            if list.last != a {
                string.append(", ")
            }
        }
        return string
    }
    
    func wobble(_ start: Bool) {
        if start {
            let angle = 0.02
            
            let wiggle = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            wiggle.values = [-angle, angle]
            wiggle.autoreverses = true
            wiggle.duration = 0.13
            wiggle.repeatCount = Float.infinity
            self.contentView.layer.add(wiggle, forKey: "wiggle")

            self.delete.isHidden = false
        } else {
            self.contentView.layer.removeAllAnimations()
            self.delete.isHidden = true
        }
    }
    
    func degreesToRadians(x: CGFloat) -> CGFloat {
        return CGFloat(Double.pi) * x / 180.0
    }
    
    class func instanceFromNib() -> UICollectionViewCell {
        return UINib(nibName: "WordCell", bundle: Bundle(for: WordCell.self)).instantiate(withOwner: self, options: nil)[0] as! UICollectionViewCell
    }

    @IBAction func deleteRequest(_ sender: UIButton) {
        deleteHandler()
    }
}
