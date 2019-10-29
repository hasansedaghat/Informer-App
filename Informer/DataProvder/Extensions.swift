//
//  Extantions.swift
//  HSExtentions
//
//  Created by Hasan Sedaghat on 11/11/17.
//  Copyright © 2017 Hasan Sedaghat. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    
    func transparentNavigationBar() {
        UINavigationBar.appearance().isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }

    func shadowNavigationBar() {
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

extension UIView {
    func roundCorners( corners: UIRectCorner , radius:CGFloat ) {

        let path = UIBezierPath(roundedRect:self.frame ,byRoundingCorners: corners ,cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        layer.masksToBounds = true
    }

    func setShadow(color:UIColor,opacity:Float,offset: CGSize,radius:CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
    
    func setShadowBazierPath(color:UIColor,opacity:Float,offset: CGSize,radius:CGFloat) {
        let bezierPath = UIBezierPath(rect: self.bounds)
        self.layer.shadowPath = bezierPath.cgPath
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        let buttonShape = CAShapeLayer()
        buttonShape.path = bezierPath.cgPath
        self.layer.mask = buttonShape
        self.layer.shouldRasterize = true
    }

    func setBorder(color:UIColor,width:CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }

    func tapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        self.endEditing(true)
    }
    
    func gradientColor(firstColor:CGColor,secondColor:CGColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [firstColor, secondColor]
        self.layer.addSublayer(gradientLayer)
    }
    
}

extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() -> Int {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
            return closestCellIndex
        }
        return 0
    }
    func currentIndexPath() -> IndexPath {
        var visibleRect = CGRect()
        visibleRect.origin = self.contentOffset
        visibleRect.size = self.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = self.indexPathForItem(at: visiblePoint) else {
            return IndexPath(row: 0, section: 0)
        }
        return indexPath
    }
}

extension UIFont {

    func bold() -> UIFont
    {
        var symTraits = fontDescriptor.symbolicTraits
        symTraits.insert([.traitBold])
        let fontDescriptorVar = fontDescriptor.withSymbolicTraits(symTraits)
        return UIFont(descriptor: fontDescriptorVar!, size: 0)
    }
}

extension Sequence {
    func group<GroupingType: Hashable>(by key: (Iterator.Element) -> GroupingType) -> [[Iterator.Element]] {
        var groups: [GroupingType: [Iterator.Element]] = [:]
        var groupsOrder: [GroupingType] = []
        forEach { element in
            let key = key(element)
            if case nil = groups[key]?.append(element) {
                groups[key] = [element]
                groupsOrder.append(key)
            }
        }
        return groupsOrder.map { groups[$0]! }
    }
}

extension UITextField {
    func setPlaceholder(text:String,color:UIColor,font:UIFont) {
        self.attributedPlaceholder = NSAttributedString(string: text,attributes: [NSAttributedString.Key.foregroundColor: color , NSAttributedString.Key.font : font])
    }
}

extension UIScrollView {
    func handleKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame:CGRect = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        var contentInset:UIEdgeInsets = self.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.contentInset = contentInset
        self.setContentOffset(CGPoint(x: 0, y: self.contentInset.bottom - 120) , animated: false)
    }

    @objc func keyboardWillHide(notification: NSNotification){
        self.contentInset.bottom = CGFloat(0)
    }

}

extension UITableView {
    func setBackgroundView(imageName:UIImage,labelText:String,labelColor:UIColor) {
        DispatchQueue.main.async {
            let superView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            let backgoundImage = UIImageView()
            backgoundImage.frame.size = CGSize(width: 110, height: 110)
            backgoundImage.center.x = superView.center.x
            backgoundImage.center.y = superView.center.y - 110
            backgoundImage.contentMode = .scaleAspectFit
            backgoundImage.image = imageName
            superView.addSubview(backgoundImage)
            let backgroundLabel = UILabel()
            backgroundLabel.frame.size = CGSize(width: superView.frame.width - 60, height: 30)
            backgroundLabel.center.x = superView.center.x
            backgroundLabel.frame.origin.y = backgoundImage.frame.origin.y + backgoundImage.frame.height + 10
            backgroundLabel.font = UIFont(name: "Vazir-FD", size: 16)
            backgroundLabel.text = labelText
            backgroundLabel.textAlignment = .center
            backgroundLabel.textColor = labelColor
            superView.addSubview(backgroundLabel)
            UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.backgroundView = superView
            }, completion: nil)
        }
    }
    func setBackgroundImage(imageName:UIImage) {
        DispatchQueue.main.async {
            let superView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            let backgoundImage = UIImageView()
            backgoundImage.frame.size = CGSize(width: 110, height: 110)
            backgoundImage.center.x = superView.center.x
            backgoundImage.center.y = superView.center.y - 50
            backgoundImage.contentMode = .scaleAspectFit
            backgoundImage.image = imageName
            superView.addSubview(backgoundImage)
            UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.backgroundView = superView
            }, completion: nil)
        }
    }

    func setBackgroundLabel(labelText:String,labelColor:UIColor,font:UIFont) {
        DispatchQueue.main.async {
            let superView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            let backgroundLabel = UILabel()
            backgroundLabel.frame.size = CGSize(width: superView.frame.width - 60, height: 90)
            backgroundLabel.center.x = superView.center.x
            backgroundLabel.frame.origin.y = superView.center.y - 45
            backgroundLabel.font = font
            backgroundLabel.text = labelText
            backgroundLabel.textAlignment = .center
            backgroundLabel.textColor = labelColor
            backgroundLabel.numberOfLines = 0
            superView.addSubview(backgroundLabel)
            UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.backgroundView = superView
            }, completion: nil)
        }
    }

    func removeBackgroundView() {
        UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
            self.backgroundView = nil
        }, completion: nil)
    }
}

extension UICollectionView {
    func setBackgroundView(imageName:UIImage,labelText:String,labelColor:UIColor,font:UIFont) {
        DispatchQueue.main.async {
            let superView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            let backgoundImage = UIImageView()
            backgoundImage.frame.size = CGSize(width: 110, height: 110)
            backgoundImage.center.x = superView.center.x
            backgoundImage.center.y = superView.center.y - 110
            backgoundImage.contentMode = .scaleAspectFit
            backgoundImage.image = imageName
            superView.addSubview(backgoundImage)
            let backgroundLabel = UILabel()
            backgroundLabel.frame.size = CGSize(width: superView.frame.width - 60, height: 30)
            backgroundLabel.center.x = superView.center.x
            backgroundLabel.frame.origin.y = backgoundImage.frame.origin.y + backgoundImage.frame.height + 10
            backgroundLabel.font = font
            backgroundLabel.text = labelText
            backgroundLabel.textAlignment = .center
            backgroundLabel.textColor = labelColor
            superView.addSubview(backgroundLabel)
            UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.backgroundView = superView
            }, completion: nil)
        }
    }
    func setBackgroundImage(imageName:UIImage,size: CGSize) {
        DispatchQueue.main.async {
            let superView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            let backgoundImage = UIImageView()
            backgoundImage.frame.size = size
            backgoundImage.center.x = superView.center.x
            backgoundImage.center.y = superView.center.y
            backgoundImage.contentMode = .scaleAspectFit
            backgoundImage.image = imageName
            superView.addSubview(backgoundImage)
            UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.backgroundView = superView
            }, completion: nil)
        }
    }

    func setBackgroundLabel(labelText:String,labelColor:UIColor,font:UIFont) {
        DispatchQueue.main.async {
            let superView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            let backgroundLabel = UILabel()
            backgroundLabel.frame.size = CGSize(width: superView.frame.width - 60, height: 90)
            backgroundLabel.center.x = superView.center.x
            backgroundLabel.frame.origin.y = superView.center.y - 45
            backgroundLabel.font = font
            backgroundLabel.text = labelText
            backgroundLabel.textAlignment = .center
            backgroundLabel.textColor = labelColor
            backgroundLabel.numberOfLines = 0
            superView.addSubview(backgroundLabel)
            UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.backgroundView = superView
            }, completion: nil)
        }
    }

    func removeBackgroundView() {
        UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
            self.backgroundView = nil
        }, completion: nil)
    }
}

extension UILabel {
    func decimalFormat() {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        let number = formatter.number(from: self.text!)
        let stringNumber = formatter.string(from: number ?? 0)
        self.text = stringNumber
    }
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}

extension String {
    func persianNumToEnglish() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "EN")
        let number = formatter.number(from: self)
        var stringNumber = formatter.string(from: number ?? 0)!
        if self.count > stringNumber.count {
            stringNumber = "0" + stringNumber
        }
        stringNumber = stringNumber.replacingOccurrences(of: " ", with: "")
        return stringNumber
    }
    func weekdayFromDate(dateFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        if let date = dateFormatter.date(from: self) {
            dateFormatter.locale = Locale(identifier: "fa_IR")
            let weekDay = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
            return weekDay
        }
        else {
            return "nil"
        }
    }
    var asDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.init(abbreviation: "GMT")
        return formatter.date(from: self)!
    }

    func toDate(format:String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.init(abbreviation: "GMT")
        return formatter.date(from: self)!
    }

    func getCleanedURL() -> URL? {
        guard self.isEmpty == false else {
            return nil
        }
        if let url = URL(string: self) {
            return url
        } else {
            if let urlEscapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) , let escapedURL = URL(string: urlEscapedString){
                return escapedURL
            }
        }
        return nil
    }

    func convertToPriceType() -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        if let number = formatter.number(from: self) {
            if let stringNumber = formatter.string(from: number) {
                return stringNumber
            }
            else {
                return self
            }
        }
        else {
            return self
        }
    }
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}


extension URL {

    mutating func appending(_ queryItem: String, value: String?) {
        var urlComponents = URLComponents(string: absoluteString)
        var queryItems: [URLQueryItem] = urlComponents?.queryItems ??  []
        let queryItem = URLQueryItem(name: queryItem, value: value)
        queryItems.append(queryItem)
        urlComponents?.queryItems = queryItems
        self = urlComponents!.url ?? URL(string: "")!
    }
}

extension UIApplication {

    var screenShot: UIImage?  {
        return keyWindow?.layer.screenShot
    }
}

extension CALayer {

    var screenShot: UIImage?  {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return screenshot
        }
        return nil
    }
}

extension Date {
    func daysFrom(date:Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: date, to: self).day
    }
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
        let delta = TimeInterval(timeZone.secondsFromGMT() - initTimeZone.secondsFromGMT())
        return addingTimeInterval(delta)
    }
}
extension Int {
    
    func toPersianNumberWords() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = Locale(identifier: "fa_IR")
        var plainText = ""
        plainText = formatter.string(from: (self as NSNumber))! + "م"
        plainText = plainText.replacingOccurrences(of: "سهم", with: "سوم")
        return plainText
    }
    
    func secondsToHoursMinutesSeconds() -> (Int, Int, Int) {
        return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    }
}


extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}
