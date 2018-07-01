//
//  ImageCell.swift
//  Hausa
//
//  Created by Emre Can Bolat on 13.02.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet var image: UIImageView!
    @IBOutlet var container: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setImage(_ signImage: SignImage) {
        if signImage.media == nil {
            OperationQueue().addOperation(BlockOperation { () -> Void in
                signImage.setMedia()
                
                OperationQueue.main.addOperation({
                    let originalImage = signImage.media
                    self.image.contentMode = .scaleAspectFit
                    self.image.image = originalImage;
                    
                    
                    //imgOne.translatesAutoresizingMaskIntoConstraints = false
                    

                })
            })
        } else {
            let originalImage = signImage.media
            self.image.contentMode = .scaleAspectFit
            self.image.image = originalImage;
            
            //imgOne.translatesAutoresizingMaskIntoConstraints = false
            

        }
    }
    
}
