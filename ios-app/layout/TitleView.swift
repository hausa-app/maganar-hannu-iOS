import UIKit

class TitleView: UIView {

    var image: UIImage!
    var height: CGFloat!
    var imageView: UIImageView!
    
    convenience init(image: UIImage, height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: (height / image.size.height) * image.size.width, height: height))
        imageView = UIImageView(image: image)
        imageView.autoresizingMask = .flexibleHeight
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.frame = bounds
        
        self.addSubview(imageView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        self.height = height
        self.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func rotated() {
        self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }

}
