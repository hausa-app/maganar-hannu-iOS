//
//  Utilities.swift
//  Hausa
//
//  Created by Emre Can Bolat on 18.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

class Utilities {
    
    static func hausaString(_ word: String) -> String {
                        
        let toReturn = word
                .replacingOccurrences(of: "ƙ", with: "k")
                .replacingOccurrences(of: "ɗ", with: "d")
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "-", with: "")
                .replacingOccurrences(of: "'", with: "")
                .replacingOccurrences(of: "?", with: "")
                .replacingOccurrences(of: "’", with: "")
                .replacingOccurrences(of: "(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .lowercased()
        return toReturn
    }
    
    static func imageString(word: String) -> String {
        let toReturn = word
            .replacingOccurrences(of: "ƙ", with: "k")
            .replacingOccurrences(of: "ɗ", with: "d")
            .replacingOccurrences(of: "?", with: "")
            .replacingOccurrences(of: "'", with: "’")
            .lowercased()
        return toReturn
    }
    
    static func getInitDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = 1980
        dateComponents.month = 7
        dateComponents.day = 11
        dateComponents.hour = 8
        dateComponents.minute = 34

        let userCalendar = Calendar.current
        
        return userCalendar.date(from: dateComponents)!
    }
    
    static func checkImageString(word: String) -> [String] {
        var name: [String] = []
        
        let string = imageString(word: word)
        name.append(word)
        
        if let range = string.range(of: "_") {
            name.append(String(string[..<range.lowerBound]))
            name.append(String(string[range.upperBound...]))
            return name
        }
        
        if let range = string.range(of: "[") {
            name.append("[")
            if string[string.index(before: range.lowerBound)] == " " {
                name.append(String(string[..<string.index(before: range.lowerBound)]))
            }
            name.append(String(string[range.upperBound...]).replacingOccurrences(of: "]", with: ""))
            return name
        }
        
        if let range = string.range(of: "@") {
            name.append("@")
            if string[string.index(before: range.lowerBound)] == " " {
                name.append(String(string[..<string.index(before: range.lowerBound)]))
            }
            name.append(String(string[string.index(after: range.upperBound)...]))
            return name
        }

        for s in string.unicodeScalars {
            if CharacterSet.decimalDigits.contains(s) {
                if let range = string.range(of: String(s)) {
                    name.append(String(string[..<string.index(before: range.upperBound)]))
                    name.append(String(string[range.lowerBound...]))
                }
                return name
            }
        }
        return name
    }
    
    static func readDataFromCSV()-> String!{
        guard let filepath = Bundle.main.path(forResource: "hausa1", ofType: "csv", inDirectory: "images")
            else {
                return nil
        }
        do {
            return try String(contentsOfFile: filepath, encoding: .utf8)
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
        
    }
    
    static func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            var columns = row.components(separatedBy: ";")
            columns.removeLast()
            
            if columns == ["", "", ""] {
                continue
            }
            
            result.append(columns)
        }
        result.removeLast()
        return result
    }
    
    static func getFileList()-> [[String]] {
        let files = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: "images")
        var stringFiles: [[String]] = []
        
        for file in files! {
            stringFiles.append([file.deletingPathExtension().lastPathComponent, "jpg"])
        }
        
        let files2 = Bundle.main.urls(forResourcesWithExtension: "png", subdirectory: "images")
        
        for file in files2! {
            stringFiles.append([file.deletingPathExtension().lastPathComponent, "png"])
        }
        
        return stringFiles
    }
    
    static func sortList(entries: [Entry]) -> [Entry] {
        
        let sorted = entries.sorted { (object1, object2) -> Bool in
            return hausaString(object1.word) < hausaString(object2.word)
        }
        return sorted
    }
    
    static func buildTime(_ date: Int64) -> String {
        var text = ""
        if date <= 60 {
            text.append("\(date % 60) sec ")
        } else if date <= 3600 {
            text.append("\((date % 3600) / 60) min ")
        } else if date <= 86400 {
            text.append("\((date % 86400) / 3600) h ")
        } else {
            text.append("\((date % 31536000) / 86400) days ")
        }
        text.append("ago")
        return text
    }

}

class StringBuilder {
    
    var value: String
    var count: Int = 0
    
    convenience init() { self.init(capacity: 16)}
    
    init(capacity: Int) {
        value = String(16)
    }
    
    convenience init(str: String) {
        self.init(capacity: str.count + 16)
        append(str: str)
    }
    
    func capacity() -> Int {
        return value.count
    }
    
    func append(obj: Any) {
        append(str: obj as! String)
    }
    
    func append(str: String){
        let len = str.count
        value.append(str)
        count += len
    }
    
    func append(s: String?, start: Int, end: Int) {
        if (start < 0 || (start > end) || (end > (s?.count)!)) {
            return
        }
        let len = end - start
        var i = start
        while (i < (s?.count)!) {
            
            value.append((s?.charAt(index: i))!)
            i += 1;
        }
        count += len
    }
}

extension UIView {
    
    func addBlurEffect(withDuration: TimeInterval) {
        let blurEffect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = frame
        addSubview(effectView)
        effectView.alpha = 0
        
        UIView.animate(withDuration: withDuration) {
            effectView.alpha = 1.0
        }
    }
    
    func removeBlurEffect(withDuration: TimeInterval) {
        for subview in subviews {
            if let blur = subview as? UIVisualEffectView {
                UIView.animate(withDuration: withDuration, animations: { blur.alpha = 0 })
            }
        }
    }
    
    func removeBlurFromSuperView() {
        for subview in subviews {
            if let blur = subview as? UIVisualEffectView {
                blur.removeFromSuperview()
            }
        }
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        
        mask.frame = self.bounds
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension CALayer {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        mask = shape
    }
}

extension UIViewController {
    
    func addBlurEffect()
    {
        for subview in view.subviews {
            if subview is UIVisualEffectView {
                return
            }
        }
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    func removeBlurEffect()
    {
        for subview in view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
        
    }
    
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

extension UICollectionView {
    
    func lastIndexPath(inSection: Int) -> IndexPath? {
        return IndexPath(item: self.numberOfItems(inSection: inSection)-1, section: inSection)
    }
    
    func getItemCount() -> Int {
        var count = 0
        for i in 0..<numberOfSections {
            count += numberOfItems(inSection: i)
        }
        return count
    }
    
    func rectForSection(section: Int) -> CGRect{
        let sectionNr = self.numberOfItems(inSection: section)
        if sectionNr <= 0 {
            return CGRect.zero
        }
        let firstRect = self.rectForRowAtIndexPath(indexPath: IndexPath(item: 0, section: section))
        let lastRect = self.rectForRowAtIndexPath(indexPath: IndexPath(item: sectionNr-1, section: section))
        return CGRect(x: 0, y: firstRect.minY, width: self.frame.width, height: lastRect.maxX - firstRect.midY)
    }
    
    func rectForRowAtIndexPath(indexPath: IndexPath) -> CGRect {
        return (self.layoutAttributesForItem(at: indexPath)?.frame)!
    }
}

extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}

enum ThemeType: Int {
    case popular = 0, recentViews = 1, recentSearches = 2, main = 3
}

public extension UIColor {
    
    public class func fuberBlue()->UIColor {
        struct C {
            static var c : UIColor = UIColor(red: 15/255, green: 78/255, blue: 101/255, alpha: 1)
        }
        return C.c
    }
    
    public class func fuberLightBlue()->UIColor {
        struct C {
            static var c : UIColor = UIColor(red: 77/255, green: 181/255, blue: 217/255, alpha: 1)
        }
        return C.c
    }
    
    public class func hausaGreen()->UIColor {
        struct C {
            static var c : UIColor = UIColor(red: 12/255, green: 92/255, blue: 42/255, alpha: 1)
        }
        return C.c
    }
    
    public class func hausaSecond()->UIColor {
        struct C {
            static var c : UIColor = UIColor(red: 24/255, green: 60/255, blue: 39/255, alpha: 1)
        }
        return C.c
    }
    
    public static func uiColorFromHex(rgbValue: Int) -> UIColor {
        
        let red =   CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(rgbValue & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static var defaultBlue: UIColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    
    static func hexStringToInt (hex:String) -> Int {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return Int(rgbValue)
    }
}

public extension Date {
    
    func format() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat = "dd.MMM.yyyy HH:mm:ss"

        return dateFormatter.string(from: self)
    }
    
    public func toInt() -> Int {
        let timeInterval = self.timeIntervalSince1970
        return Int(timeInterval)
    }

}

extension Int {
    
    public func toDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self / 1000))
    }
    
}

extension Int64 {
    
    public func toDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self / 1000))
    }
    
}


extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    func format() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date = dateFormatter.date(from: self) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        return date
        
    }
    
    func charAt(index: Int) -> String {
        let lowerBound = self.index(self.startIndex, offsetBy: index)
        let upperBound = self.index(self.startIndex, offsetBy: index+1)
        return String(self[lowerBound..<upperBound])
    }
    
    func indexOf(target: String, fromIndex_: Int) -> Int {
        var fromIndex = fromIndex_
        if fromIndex >= self.count {
            return target.count == 0 ? self.count : -1
        }
        if fromIndex < 0 {
            fromIndex = 0
        }
        if target.count == 0 {
            return fromIndex
        }

        let first = target.charAt(index: 0)
        let max = self.count - target.count
        
        let i = fromIndex
        for i in (i...max) {
            
            while ((i+1 <= max && self.charAt(index: i) != first)) {
                if self.charAt(index: i) != first {break}
            }
            
            if i <= max {
                var j = i + 1
                let end = j + target.count - 1
                var k = 1
                
                while (j < end && self.charAt(index: j) == target.charAt(index: k)) {
                    j += 1
                    k += 1
                }
                
                if j == end {
                    return i
                }
            }
        }
        return -1
    }
    
    func fastSubstring(beginIndex: Int, subLen: Int?) -> String {
        var length: Int
        if subLen == nil {
            length = self.count
        } else {
            length = subLen!
        }
        
        let lowerBound = self.index(self.startIndex, offsetBy: beginIndex)
        let upperBound = self.index(self.startIndex, offsetBy: length)
        
        return String(self[lowerBound..<upperBound])
    }
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension UILabel {
    
    public static func estimatedSize(_ text: String, targetSize: CGSize = .zero) -> CGSize {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.text = text
        return label.sizeThatFits(targetSize)
    }
}

