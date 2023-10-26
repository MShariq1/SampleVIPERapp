//
//  Extentions.swift
//  Dragon Fly
//
//  Created by A1398 on 06/04/2021.
//

import UIKit
import MapKit
import Contacts

private var bottomLineColorAssociatedKey : UIColor = .black
private var topLineColorAssociatedKey : UIColor = .black
private var rightLineColorAssociatedKey : UIColor = .black
private var leftLineColorAssociatedKey : UIColor = .black

extension Date {
    
    // Convert local time to UTC (or GMT)
    func toUTC() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toGMT() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func toString(withFormat format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        let myString = formatter.string(from: self)
        let yourDate = formatter.date(from: myString)
        //        if AppStateManager.shared.isArabic() {
        //            formatter.locale = Locale(identifier: "ar")
        //        }
        formatter.dateFormat = format.rawValue
        
        return formatter.string(from: yourDate!)
    }
    
    func getUTCFormateDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        let timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    
    func isInSameWeek(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }
    func isInSameMonth(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    func isInSameYear(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .year)
    }
    func isInSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
    
    var isInThisWeek: Bool {
        return isInSameWeek(date: Date())
    }
    
    //    var isInToday: Bool {
    //        return Calendar.current.isDateInToday(self)
    //    }
    
    var isInTheFuture: Bool {
        return Date() < self
    }
    
    var isInThePast: Bool {
        return self < Date()
    }
    
    /// Returns a Date with the specified days added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        var targetDay: Date
        targetDay = Calendar.current.date(byAdding: .year, value: years, to: self)!
        targetDay = Calendar.current.date(byAdding: .month, value: months, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .day, value: days, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .hour, value: hours, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .minute, value: minutes, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .second, value: seconds, to: targetDay)!
        return targetDay
    }
    
    /// Returns a Date with the specified days subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        let inverseYears = -1 * years
        let inverseMonths = -1 * months
        let inverseDays = -1 * days
        let inverseHours = -1 * hours
        let inverseMinutes = -1 * minutes
        let inverseSeconds = -1 * seconds
        return add(years: inverseYears, months: inverseMonths, days: inverseDays, hours: inverseHours, minutes: inverseMinutes, seconds: inverseSeconds)
    }
    
    func getCurrentMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func differenceInDays(from: Date) -> Int? {
        let diffInDays = Calendar.current.dateComponents([.day], from: from, to: self).day
        return diffInDays
    }
    
}

extension UILabel {
    
    func setFont(type: FontType, ofSize size: CGFloat) {
        self.font = UIFont(name: type.rawValue, size: size)!
    }
    
    func addMilage(text1: String, text2: String, size: CGFloat = 13) {
        
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage(named:"milage")?.colorImage(with: .white)
        imageAttachment1.bounds = CGRect(x: 0, y: 0, width: size + size*1.55*0.3, height: size*0.8)
        
        
        let imageAttachment2 = NSTextAttachment()
        imageAttachment2.image = UIImage(named:"distance")?.colorImage(with: .white)
        imageAttachment2.bounds = CGRect(x: 0, y: -size*0.1, width: size*0.75*0.9, height: size*0.9)
       
        let attachmentString1 = NSAttributedString(attachment: imageAttachment1)
        let attachmentString2 = NSAttributedString(attachment: imageAttachment2)
        
        let completeText = NSMutableAttributedString(string: "")//text1 + "   "
        completeText.append(attachmentString1)
        completeText.append(NSAttributedString(string: "   " + text1 + "    "))
        completeText.append(attachmentString2)
        completeText.append(NSAttributedString(string: "   " + text2))
        
        self.attributedText = completeText
        
    }
    
    func PopDescLineSpacing() {
        self.textAlignment = .center
        self.font = self.font.withSize(14)
//        self.setFont(type: FontType(rawValue: "Graphik-Regular")!, ofSize: 5)
    }
    
    func addInterlineSpacing(spacingValue: CGFloat = 2) {
        guard let textString = text else { return }
        let attributedString = NSMutableAttributedString(string: textString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacingValue
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
        ))
        attributedText = attributedString
    }
    
}

extension UIImage {
    func colorImage(with color: UIColor) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        UIGraphicsBeginImageContext(self.size)
        let contextRef = UIGraphicsGetCurrentContext()

        contextRef?.translateBy(x: 0, y: self.size.height)
        contextRef?.scaleBy(x: 1.0, y: -1.0)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)

        contextRef?.setBlendMode(CGBlendMode.normal)
        contextRef?.draw(cgImage, in: rect)
        contextRef?.setBlendMode(CGBlendMode.sourceIn)
        color.setFill()
        contextRef?.fill(rect)

        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return coloredImage
    }
}

extension UIImageView {

    func addGradientLayer(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        self.layer.addSublayer(gradient)
    }
    
//    func showFullScreenPreview(vc: UIViewController?) {
//        let configuration = ImageViewerConfiguration { config in
//            config.imageView = self
//        }
//
//        let imageViewerController = ImageViewerController(configuration: configuration)
//
//        vc?.present(imageViewerController, animated: true)
//    }
}

extension Character {
    
    fileprivate func isEmoji() -> Bool {
        return Character(UnicodeScalar(UInt32(0x1d000))!) <= self && self <= Character(UnicodeScalar(UInt32(0x1f77f))!)
            || Character(UnicodeScalar(UInt32(0x2100))!) <= self && self <= Character(UnicodeScalar(UInt32(0x26ff))!)
    }
}

extension Notification.Name {
    static let reloadNewsFeed = Notification.Name("reloadNewsFeed")
    static let refreshChat = Notification.Name("refreshChat")
    static let stopTimerSingle = Notification.Name("stopTimerSingle")
    static let stopTimerGroup = Notification.Name("stopTimerGroup")
    static let addPeople = Notification.Name("addPeople")
    static let selectedConnectionForEnquiry = Notification.Name("selectedConnectionForEnquiry")
    static let didReceiveData = Notification.Name("didReceiveData")
}

extension Optional where Wrapped == String {
    var value: String {
        return self ?? ""
    }
}

extension UIView {
    
    func blink(numberOfFlashes: Float = 10000) {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = numberOfFlashes
        layer.add(flash, forKey: nil)
    }
    
    func fixInView(_ container: UIView!) -> Void{
                self.translatesAutoresizingMaskIntoConstraints = false;
                self.frame = container.frame;
                container.addSubview(self);
                NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
                NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
                NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
                NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
            }
}

extension String {
    
    func bidBoxToAuction() -> String {
        return self.replacingOccurrences(of: "Bidbox", with: "Auction", options: .literal, range: nil).replacingOccurrences(of: "Pending", with: "Upcoming", options: .literal, range: nil).replacingOccurrences(of: "Inactive", with: "Auction start date not set", options: .literal, range: nil)
    }
    
    func bidBoxToAuctionfordetail() -> String {
        return self.replacingOccurrences(of: "Bidbox", with: "Auction", options: .literal, range: nil).replacingOccurrences(of: "Pending", with: "Pending to go live", options: .literal, range: nil).replacingOccurrences(of: "Inactive", with: "Auction start date not set", options: .literal, range: nil)
    }
    
    func removeGreaterLess() -> String {
        return self.replacingOccurrences(of: "&lt;", with: "<", options: .literal, range: nil).replacingOccurrences(of: "&gt;", with: ">", options: .literal, range: nil)
    }
    
    func inactiveChange() -> String {
        return self.replacingOccurrences(of: "Inactive", with: "Auction start date not set", options: .literal, range: nil)
    }
    
    func getFlag() -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in self.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    func withCommas() -> String {
        let int = Int(self) ?? 0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:int))!
    }
    
    func removeBullets() -> String {
        return self.replacingOccurrences(of: "<ul>", with: "")
        .replacingOccurrences(of: "</ul>", with: "")
        .replacingOccurrences(of: "<li>", with: "")
        .replacingOccurrences(of: "</li>", with: "")
        .replacingOccurrences(of: "<span>", with: "")
        .replacingOccurrences(of: "</span>", with: "")
        //.replacingOccurrences(of: "&nbsp;", with: "")
    }
    
    public func trimHTMLTags() -> String? {
        guard let htmlStringData = self.data(using: String.Encoding.utf8) else {
            return nil
        }
    
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
    
        let attributedString = try? NSAttributedString(data: htmlStringData, options: options, documentAttributes: nil)
        return attributedString?.string
    }
    
    func digitsOnly() -> String{
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    func getDateUTC(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: dt!)
    }
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    func getDateUTC(initalFormat: String, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = initalFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: dt!)
    }
    
    func localToUTC(initialFormat: String, returnFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = initialFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = returnFormat
        
        return dateFormatter.string(from: dt!)
    }
    
    func stringByRemovingEmoji() -> String {
        return String(self.filter { !$0.isEmoji() })
    }
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    func isValidEmail() -> Bool {
        let emalRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let result = NSPredicate(format:"SELF MATCHES %@", emalRegex)
        return result.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let password = self.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)

    }
    func isValidName() -> Bool {
        let RegEx = "(?<! )[-a-zA-Z' ]{2,26}"
        let nameCheck = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return nameCheck.evaluate(with: self)
    }

    var isPhoneNumber: Bool {
        if (self.count < 11) {
            return false
        }
        let characters = CharacterSet.decimalDigits.inverted
        return !self.isEmpty && rangeOfCharacter(from: characters) == nil
    }
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.endIndex.encodedOffset
        } else {
            return false
        }
    }
    
    func isValidString() -> Bool {
        let trimmedString = self.replacingOccurrences(of: "&nbsp", with: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return !trimmedString.isEmpty
    }
    
    func isSuccessResponse() -> Bool {
        return self == "success"
    }
    
    var html2AttributedString: NSAttributedString? {
        return self.data(using: .utf8)?.html2AttributedString
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
    
    func toDouble() -> Double {
        return (NumberFormatter().number(from: self)?.doubleValue) ?? 0.0
    }
    
    func toFloat() -> Float {
        return (NumberFormatter().number(from: self)?.floatValue) ?? 0.0
    }
    
    func toInt() -> Int {
        return (NumberFormatter().number(from: self)?.intValue) ?? 0
    }

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }

    var containsWhitespace : Bool {
        return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
    
    func getSpaceCount() -> Int {
        let count = self.components(separatedBy:" ").count
        if count > 0 {
            return count - 1
        } else {
            return 0
        }
    }
    
    func getTextHeight(approxWidth: CGFloat, font: UIFont) -> CGFloat {
        return getTextFrame(approxWidth: approxWidth, font: font).height
    }
    
    func getTextFrame(approxWidth: CGFloat, font: UIFont) -> CGRect {
        let size = CGSize(width: approxWidth, height: CGFloat(Float.infinity))
        let attributes = [NSAttributedString.Key.font: font]
        return NSString(string: self).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
    }
}

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}


extension UIView {
    
    public func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    public func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
    
    public func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        _ = anchorWithReturnAnchors(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant, widthConstant: widthConstant, heightConstant: heightConstant)
    }
    
    public func anchorWithReturnAnchors(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leadingAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(trailingAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    public func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
    
    
    func rotate(degrees: CGFloat) {
        rotate(radians: CGFloat.pi * degrees / 180.0)
    }
    
    func rotate(radians: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
    
    func move(x: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform(translationX: x, y: y)
    }
    
    func topLine(x: CGFloat = 0.0, y: CGFloat = 0.0, width: CGFloat? = nil, color: UIColor = .lightGray, height: CGFloat = 0.5) {
        let topLine: UIView
        if let width = width {
            topLine = UIView(frame: CGRect.init(x: x, y: y, width: width, height: height))
        } else {
            topLine = UIView(frame: CGRect.init(x: x, y: y, width: self.frame.width, height: height))
        }
        topLine.backgroundColor = color
        self.addSubview(topLine)
        
    }
    
    
    func pinToInside(view child: UIView) {
        child.translatesAutoresizingMaskIntoConstraints = false
        addSubview(child)
        NSLayoutConstraint.activate([
            child.leadingAnchor.constraint(equalTo: leadingAnchor),
            child.trailingAnchor.constraint(equalTo: trailingAnchor),
            child.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            child.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
    }
}

extension UICollectionViewCell {
    
    class var storyboardId : String {
        return "\(self)"
    }
    
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!;
    }
}

extension NSMutableAttributedString {
    func makeBold(items: [String], fontItems: [String], size: CGFloat = 12) -> NSMutableAttributedString {
        let attributedString = self
        for item in items {
            let range = (attributedString.string as NSString).range(of: item)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.mainFont(ofSize: size), range: range)
        }
        for item in fontItems {
            let range = (attributedString.string as NSString).range(of: item)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.mainFont(ofSize: size + 1), range: range)
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
        ))
        return attributedString
    }
}

public extension UIFont {
    static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    static func mainFont(ofSize size: CGFloat, family: fontFamily = .bold) -> UIFont {
        switch family {
        case .bold:
            return customFont(name: "Poppins-Bold", size: size)
        case .extraBold:
            return customFont(name: "Poppins-ExtraBold", size: size)
        case .regular:
            return customFont(name: "Poppins-Regular", size: size)
        case .medium:
            return customFont(name: "Poppins-Medium", size: size)
        }
        
    }
    
    static func mainSemiBold(ofSize size: CGFloat,isBold : Bool = false) -> UIFont {
        return customFont(name: "Geometria-Bold", size: size)
    }
}

extension UIView {
    
    func setAnchorPoint(anchorPoint: CGPoint) {

         var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
         var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x, y: self.bounds.size.height * self.layer.anchorPoint.y)

         newPoint = newPoint.applying(self.transform)
         oldPoint = oldPoint.applying(self.transform)

         var position : CGPoint = self.layer.position

         position.x -= oldPoint.x
         position.x += newPoint.x;

         position.y -= oldPoint.y;
         position.y += newPoint.y;

         self.layer.position = position;
         self.layer.anchorPoint = anchorPoint;
     }
    
    func animateView(duration:Double = 0.25, scrollBounds:CGFloat = 0, transform:CGFloat = 0, shouldAnimate: Bool = true, hide: Bool = false) {
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn],
                               animations: {
                                if shouldAnimate {
                                    self.center.y -= (self.bounds.height - scrollBounds)
                                }
                                if transform > 0 {
//                                    self.center.x = 50
                                    self.alpha = 1.0
                                    self.transform = CGAffineTransform(scaleX: transform, y: transform)
                                }
                                self.layoutIfNeeded()
                }, completion: nil)
        self.isHidden = hide
        
//        UIView.animate(withDuration: 1, animations: {
//
//        }) { (finished) in
//            UIView.animate(withDuration: 1, animations: {
//                yourView.transform = CGAffineTransform.identity
//            })
//        }
    }
    func hideAnimation(duration:Double = 0.25, scrollBounds:CGFloat = 0, transform:CGFloat = 0, shouldAnimate: Bool = true){
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut],
                       animations: {
                        if shouldAnimate {
                            self.center.y += (self.bounds.height - scrollBounds)
                            self.center.x = UIScreen.main.bounds.width/2
                        }
                        if transform > 0 {
                            self.transform = CGAffineTransform(scaleX: transform, y: transform)
                        }
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }
    
    func setBorder(width: CGFloat = 1, color: UIColor = .AppBGGray) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func slightRound(radius: CGFloat = 15, isFullRound: Bool? = true, isBorder: Bool = false, color: UIColor = .gray) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        
        if isBorder {
            self.layer.borderWidth = 1
            self.layer.borderColor = color.cgColor
        } else {
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func halfRound() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
    
    func completeRound() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func completeRect() {
        self.layer.cornerRadius = 0
        self.clipsToBounds = true
    }
    
    func roundAndShadow() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 3.0
    }
    
    func addHeavyDropShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.masksToBounds = false
    }
    
    
          
    
    func addDropShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5.0
        layer.masksToBounds = false
    }
    
    func addDropShadowToTop() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -3.0)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5.0
        layer.masksToBounds = false
    }
    
    func addDropStroke() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 1
        layer.shadowRadius = 5.0
        layer.masksToBounds = false
    }
    
    
    func unrealRoundAndShadow2(shadowColor: UIColor = UIColor.lightGray,
                    fillColor: UIColor = UIColor.white,
                    opacity: Float = 0.6,
                    offset: CGSize = CGSize(width: 0.0, height: 3.0),
                    radius: CGFloat = 10) -> CAShapeLayer {
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10).cgPath
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = 3.0
        layer.insertSublayer(shadowLayer, at: 0)
        return shadowLayer
    }
    
    func unrealRoundAndShadow() {
        let containerView = UIView()
        
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 3.0
        
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = self.backgroundColor
        
        layer.backgroundColor = UIColor.clear.cgColor
        
//        addSubview(containerView)
        insertSubview(containerView, at: 0)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        self.layoutIfNeeded()
        print(self.frame.height)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
    
    func roundCorners1(corners: [UIRectCorner], radius: CGFloat) {
        var newCorners = CACornerMask()
        
        for item in corners {
            switch item {
                case .topLeft: newCorners.insert(.layerMinXMinYCorner)
                case .topRight: newCorners.insert(.layerMaxXMinYCorner)
                case .bottomLeft: newCorners.insert(.layerMinXMaxYCorner)
                case .bottomRight: newCorners.insert(.layerMaxXMaxYCorner)
            default: break
            }
        }
        layer.cornerRadius = radius
        layer.maskedCorners = newCorners
    }
    
    func setMyMessageCorners() {
        self.roundCorners1(corners: [.topLeft, .topRight, .bottomLeft], radius: 21)
    }
    func setMyTopMessageCorners() {
        self.roundCorners1(corners: [.topLeft, .bottomLeft, .bottomRight], radius: 21)
    }
    func setMyMidMessageCorners() {
        self.roundCorners1(corners: [.topLeft, .bottomLeft, .topRight], radius: 21)
    }
    func setMyBottomMessageCorners() {
        self.roundCorners1(corners: [.topLeft, .topRight, .bottomLeft], radius: 21)
    }
    
    func newMyBottomMessageCorners() {
        self.roundCorners1(corners: [.topLeft, .bottomRight, .bottomLeft], radius: 21)
    }
    
    
    func setOtherMessageCorners() {
        self.roundCorners1(corners: [.topRight, .bottomRight, .bottomLeft], radius: 21)
    }
    func setOtherTopMessageCorners() {
        self.roundCorners1(corners: [.topRight, .bottomRight, .topLeft], radius: 21)
    }
    func setOtherMidMessageCorners() {
        self.roundCorners1(corners: [.topRight, .bottomRight], radius: 21)
    }
    func setOtherBottomMessageCorners() {
        self.roundCorners1(corners: [.topRight, .bottomRight, .bottomLeft], radius: 21)
    }
    
    func addConstraintsWithFormatString(formate: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formate, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
    
    func layerBlackGradient(_ cornerRadius: Int = 0) {
        let gradient: CAGradientLayer = CAGradientLayer()
        let startColor = UIColor.black.withAlphaComponent(0.4).cgColor
        let endStart = UIColor.clear.cgColor

        gradient.colors = [startColor, endStart]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = self.bounds
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        if cornerRadius > 0 {
            gradient.cornerRadius = CGFloat(cornerRadius)
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIButton {
    func btnSlightRound(radius: CGFloat = 10, fontSize: CGFloat = 13) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.mainSemiBold(ofSize: fontSize)
    }
    
    func addCharacterSpacing(kernValue: Double = 1.15) {
        if let labelText = self.titleLabel?.text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            self.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    func setNonUserLogin() {
        self.slightRound(radius: self.frame.height/2)
        self.backgroundColor = UIColor.HandleBorderBlue
        self.setTitle("Login Now", for: .normal)
        self.titleLabel?.font = UIFont.mainFont(ofSize: 11)
        self.setTitleColor(.white, for: .normal)
    }
    
    func setNonUserSignup() {
        self.slightRound(radius: self.frame.height/2)
        self.backgroundColor = UIColor.white
        self.setTitle("Sign Up", for: .normal)
        self.titleLabel?.font = UIFont.mainFont(ofSize: 11)
        self.setTitleColor(.HandleBorderBlue, for: .normal)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.HandleBorderBlue.cgColor
    }
}

extension UIImage {

func tintedWithLinearGradientColors(colorsArr: [CGColor]) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
    guard let context = UIGraphicsGetCurrentContext() else {
        return UIImage()
    }
    context.translateBy(x: 0, y: self.size.height)
    context.scaleBy(x: 1, y: -1)

    context.setBlendMode(.normal)
    let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)

    // Create gradient
    let colors = colorsArr as CFArray
    let space = CGColorSpaceCreateDeviceRGB()
    let gradient = CGGradient(colorsSpace: space, colors: colors, locations: nil)

    // Apply gradient
    context.clip(to: rect, mask: self.cgImage!)
    context.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: self.size.height), options: .drawsAfterEndLocation)
    let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return gradientImage!
}
}


extension UIView {
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromMyView!
    }
    
 
    
    @objc func toImageView() -> UIImageView {
        let tempImageView = UIImageView()
        tempImageView.image = toImage()
        tempImageView.frame = frame
        tempImageView.contentMode = .scaleAspectFit
        return tempImageView
    }
    
    @discardableResult
    func applyHorizontalGradient(colours: [UIColor] = [UIColor.AppStartGradient, UIColor.AppMidGradient, UIColor.AppEndGradient], corners: [UIRectCorner]? = nil, radius: CGFloat = 15) -> CAGradientLayer {
        return self.applyHorizontalGradient(colours: colours, locations: [0.0, 0.5, 1.0], corners: corners, radius: radius)
    }
    
    @discardableResult
    fileprivate func applyHorizontalGradient(colours: [UIColor], locations: [NSNumber]?, corners: [UIRectCorner]? = nil, radius: CGFloat) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0,y: 0.5)
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        
        
        if let corners = corners {
            var newCorners = CACornerMask()
            for item in corners {
                switch item {
                    case .topLeft: newCorners.insert(.layerMinXMinYCorner)
                    case .topRight: newCorners.insert(.layerMaxXMinYCorner)
                    case .bottomLeft: newCorners.insert(.layerMinXMaxYCorner)
                    case .bottomRight: newCorners.insert(.layerMaxXMaxYCorner)
                default: break
                }
            }
            gradient.cornerRadius = 15
            gradient.maskedCorners = newCorners
        }
        
        
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    @discardableResult
    func applyVerticalGradient(colours: [UIColor] = [UIColor.AppRedTheme, UIColor.AppMidGradient, UIColor.AppEndGradient], corners: [UIRectCorner]? = nil, radius: CGFloat = 15) -> CAGradientLayer {
        return self.applyVerticalGradient(colours: colours, locations: [0.0, 0.5, 1.0], corners: corners, radius: radius)
    }
    
    @discardableResult
    fileprivate func applyVerticalGradient(colours: [UIColor], locations: [NSNumber]?, corners: [UIRectCorner]? = nil, radius: CGFloat) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.5,y: 1.0)
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.name = "Gradient"
        
        if let corners = corners {
            var newCorners = CACornerMask()
            for item in corners {
                switch item {
                    case .topLeft: newCorners.insert(.layerMinXMinYCorner)
                    case .topRight: newCorners.insert(.layerMaxXMinYCorner)
                    case .bottomLeft: newCorners.insert(.layerMinXMaxYCorner)
                    case .bottomRight: newCorners.insert(.layerMaxXMaxYCorner)
                default: break
                }
            }
//            gradient.cornerRadius = radius
            gradient.maskedCorners = newCorners
        }
        
        self.layer.insertSublayer(gradient, at: 0)
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        return gradient
    }
}

extension UIViewController {
    
    func addRedDotAtTabBarItemIndex(index: Int, isAdd: Bool) {
        if tabBarController == nil {
            return
        }
        
        for subview in tabBarController!.tabBar.subviews {
            if subview.tag == index + 100 {
                subview.removeFromSuperview()
                break
            }
        }
        
        if !isAdd {
            return
        }
        
        let RedDotRadius: CGFloat = 5
        let RedDotDiameter = RedDotRadius * 2
        let TopMargin:CGFloat = 5
        let TabBarItemCount = CGFloat(self.tabBarController!.tabBar.items!.count)
        let screenSize = UIScreen.main.bounds
        let HalfItemWidth = (screenSize.width) / (TabBarItemCount * 2)
        let  xOffset = HalfItemWidth * CGFloat(index * 2 + 1)
        
        let imageHalfWidth: CGFloat = (self.tabBarController!.tabBar.items![index] ).selectedImage!.size.width / 2
        let redDot = UIView(frame: CGRect(x: xOffset + imageHalfWidth + 15, y: TopMargin, width: RedDotDiameter, height: RedDotDiameter))
        redDot.backgroundColor = UIColor.colorFromHex("FF2200")
        redDot.layer.cornerRadius = RedDotRadius
        redDot.tag = index + 100
        self.tabBarController?.tabBar.addSubview(redDot)
    }
    
    class var storyboardId : String {
        return "\(self)"
    }
    
    func removeChild() {
        self.children.forEach {
            $0.didMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!;
    }
    
//    static func springAnimationTabBarDeck(vc: UIViewController) {
//        if let vc = vc.tabBarController?.viewControllers?[2] {
//            if let tabBar = vc.tabBarController as? TabbarVC {
//                let orderedTabBarItemViews: [UIView] = {
//                    let interactionViews = tabBar.tabBar.subviews.filter({ $0 is UIControl })
//                    return interactionViews.sorted(by: { $0.frame.minX < $1.frame.minX })
//                }()
//                guard let subview = orderedTabBarItemViews[2].subviews.first else { return }
//                subview.tintColor = .HandleBorderBlue
//                tabBar.performSpringAnimation(for: subview, scale: 3.0)
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                    subview.tintColor = .AppLightGray
//
//                }
//            }
//        }
//    }
    
    static func performHorizontalSpringAnimation(for view: UIImageView, scale: CGFloat = 1.25) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.repeat, .curveLinear], animations: {
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }, completion: nil)
    }
}

func URLforRoute(route: String,params:[String: Any]) -> NSURL? {
        if let components: NSURLComponents  = NSURLComponents(string: route){
            var queryItems = [NSURLQueryItem]()
            for(key,value) in params {
                queryItems.append(NSURLQueryItem(name:key,value: "\(value)"))
            }
            components.queryItems = queryItems as [URLQueryItem]?
            return components.url as NSURL?
        }
        return nil
    }


extension UINavigationController {
    func applyTransition(type: CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = type
        self.view.layer.add(transition, forKey: kCATransition)
    }
    var previousViewController: UIViewController? {
        return viewControllers.count > 1 ? viewControllers[viewControllers.count - 2] : nil
    }
    
    func popViewControllers(popViews: Int, animated: Bool = true) {
        if self.viewControllers.count > popViews {
            let vc = self.viewControllers[self.viewControllers.count - popViews - 1]
             self.popToViewController(vc, animated: animated)
        }
    }
    
    func setToDefault() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = false
        self.view.backgroundColor = .clear
        self.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.mainFont(ofSize: 26, family: .extraBold),
            NSAttributedString.Key.foregroundColor: UIColor.purple
        ]
    }
    
    func backToViewController(vc: Any) {
        // iterate to find the type of vc
        for element in viewControllers as Array {
            if "\(type(of: element)).Type" == "\(type(of: vc))" {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
    

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
      }

    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
      }
    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try? NSAttributedString(data: self , options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            //return html
        } catch {
            print("error:", error)
            return  nil
        }
    }
}

extension UITableView {
    
    func scrollToBottom(isAnimated: Bool = true){
        
        DispatchQueue.main.async {
            let sections = self.numberOfSections
            let rows = self.numberOfRows(inSection: sections - 1)
            self.scrollToRow(at: NSIndexPath(row: rows - 1, section: sections - 1) as IndexPath, at: .bottom, animated: false)
            
//            let indexPath = IndexPath(
//                row: self.numberOfRows(inSection:  (self.numberOfSections - 1)) - 1,
//                section: self.numberOfSections - 1)
//            if self.numberOfSections > indexPath.section && self.numberOfRows(inSection: 0) > indexPath.row && indexPath.row >= 0 && indexPath.section >= 0 {
//                self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
//            }
        }
    }
    
    func scrollToIndex(isAnimated: Bool = true, index: Int, section: Int = 0, shouldScroll: Bool = true){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: index,
                section: section) //section - 1) //self.numberOfSections - 1)
//            if self.numberOfSections > indexPath.section && self.numberOfRows(inSection: self.numberOfSections - 1) > indexPath.row && indexPath.row >= 0 && indexPath.section >= 0 {
            self.scrollToRow(at: indexPath, at: shouldScroll ? (isAnimated ? .bottom : .top) : .none, animated: isAnimated)
//            }
        }
    }
    
    func scrollToTop(isAnimated: Bool = false) {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
        }
    }
}

extension Array {
  func sliced(by dateComponents: Set<Calendar.Component>, for key: KeyPath<Element, Date>) -> [Date: [Element]] {
    let initial: [Date: [Element]] = [:]
    let groupedByDateComponents = reduce(into: initial) { acc, cur in
      let components = Calendar.current.dateComponents(dateComponents, from: cur[keyPath: key])
      let date = Calendar.current.date(from: components)!
      let existing = acc[date] ?? []
      acc[date] = existing + [cur]
    }

    return groupedByDateComponents
  }
}

extension NSMutableAttributedString {
    
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
    func setCustomAttributedText(textOne: String, textTwo: String, titleFont: UIFont, detailFont: UIFont, titleColor: UIColor, detailColor:UIColor) -> NSMutableAttributedString {
        let yourAttributes = [NSAttributedString.Key.foregroundColor: titleColor, NSAttributedString.Key.font:titleFont]
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: detailColor, NSAttributedString.Key.font:detailFont]
        
        let partOne = NSMutableAttributedString(string: textOne, attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: textTwo, attributes: yourOtherAttributes)
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        return combination
    }
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
    func setBoldForText(textForAttribute: String) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(.font, value: UIFont.mainFont(ofSize: 13), range: range)
    }
    
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.mainFont(ofSize: 14)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        boldString.setColor(color: .white, forText: boldString.string)
        append(boldString)
        
        return self
    }
    @discardableResult func bold1(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Helvetica-Bold", size: 14)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        boldString.setColor(color: .black, forText: boldString.string)
        append(boldString)
        
        return self
    }
    
    @discardableResult func regular(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.mainFont(ofSize: 14)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        boldString.setColor(color: .AppLightestGray, forText: boldString.string)
        append(boldString)
        
        return self
    }
    
    
    @discardableResult func addLineSpacing(_ lineSpacing: CGFloat) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: self.length
        ))
        
        return self
    }
    
}

extension UIView {
    
    func setSlightRoundBorder() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.AppLightestGray.cgColor
    }
    
    func bounceAnimation() {
        UIView.animate(withDuration: 0.3,
        animations: {
            self.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        },
        completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform.identity
            }
        })
    }
    
    func slightBounceAnimation() {
        UIView.animate(withDuration: 0.1,
        animations: {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        },
        completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform.identity
            }
        })
    }
    
}


extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    var clean: String {
        return String(format: "%.0f", self)
    }
}


extension Sequence where Self.Element == String {

  func toBulletList(_ bulletIndicator: String = "•", itemSeparator: String = "\n", spaceCount: Int = 2) -> String {
    let bullet = bulletIndicator + String(repeating: " ", count: spaceCount)
    let list = self.map { bullet + $0 }.reduce("", { $0 + ($0.isEmpty ? $0 : itemSeparator) + $1 })
    return list
  }

}


extension Bundle {

    public static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    public static var appBuild: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

    public static func _version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) build \(build)"
    }

    public static var appTarget: String? {
        if let targetName = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String {
            return targetName
        }
        return nil
    }
}

extension Int {
    
    func increment() -> Int {
        return self + 1
    }
    
    func decrement() -> Int {
        return self - 1
    }
    
    func decrement(minValue: Int) -> Int {
        return self == minValue ? self : self - 1
    }
    
    func toString() -> String? {
        return String(self)
    }
}

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}

extension UIColor {

  
    public static let AppRedTheme = UIColor.brown
    public static let AppWhiteColor = UIColor.white
    public static let AppBorderLightGray = UIColor.lightGray
    public static let AppBlackColor = UIColor.black
    public static let AppBGGray = UIColor.lightGray
    public static let progressFrstGrad = UIColor.red
    public static let progressScndGrad = UIColor.green
    public static let progressThrdGrad = UIColor.yellow
    
    public static let AppStartGradient = UIColor.brown.withAlphaComponent(0.3)
    public static let AppMidGradient = UIColor.brown.withAlphaComponent(0.6)
    public static let AppEndGradient = UIColor.brown.withAlphaComponent(0.9)
    public static let AppTagSkyBlue = UIColor.blue
    public static let HandleBorderBlue = UIColor.blue
    public static let AppLightestGray = UIColor.lightGray
    public static let AppRed = UIColor.red
    public static let AppGreen = UIColor.green
    public static let AppPurple = UIColor.purple
    
    
    static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static func colorFromHex(_ hex: String) -> UIColor {
        
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        if hexString.count != 6 {
            return UIColor.magenta
        }
        var rgb: UInt32 = 0
        Scanner.init(string: hexString).scanHexInt32(&rgb)
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16)/255,
                            green: CGFloat((rgb & 0x00FF00) >> 8)/255,
                            blue: CGFloat(rgb & 0x0000FF)/255,
                            alpha: 1.0)
    }
    
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIViewController {
    
    func repairTabbarOverlapping(table: UITableView) {
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        table.contentInset = adjustForTabbarInsets
        table.scrollIndicatorInsets = adjustForTabbarInsets
    }
    
//    func setupNavBar(navBar: BackNavBar) {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = UIColor.clear
//        navBar.frame = CGRect(x: 0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: ((navigationController?.navigationBar.frame.height)! + 100))
//        self.navigationController?.navigationBar.addSubview(navBar)
////        self.navigationController?.navigationBar.bringSubviewToFront(navBar)
//        navBar.setupNav(leftImage: "back button", rightImage: "filter icon", title: "WOW")
//        navBar.leftBtn.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
//        navBar.rightButton.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
//    }
    
    @objc func leftAction(_ sender: UIButton) {
        print("Left button clicked")
    }
    
    @objc func rightAction(_ sender: UIButton) {
        print("right button clicked")
    }
}

extension UIView {
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width,y: 0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    @IBInspectable var corners_radius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var border_width: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var border_color: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    //Individual Lines
    @IBInspectable var bottomLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &bottomLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &bottomLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBInspectable var bottomLineWidth: CGFloat {
        get {
            return self.bottomLineWidth
        }
        set {
            DispatchQueue.main.async {
                self.addBottomBorderWithColor(color: self.bottomLineColor, width: newValue)
            }
        }
    }
    @IBInspectable var topLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &topLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &topLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBInspectable var topLineWidth: CGFloat {
        get {
            return self.topLineWidth
        }
        set {
            DispatchQueue.main.async {
                self.addTopBorderWithColor(color: self.topLineColor, width: newValue)
            }
        }
    }
    @IBInspectable var rightLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &rightLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &rightLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBInspectable var rightLineWidth: CGFloat {
        get {
            return self.rightLineWidth
        }
        set {
            DispatchQueue.main.async {
                self.addRightBorderWithColor(color: self.rightLineColor, width: newValue)
            }
        }
    }
    @IBInspectable var leftLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &leftLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &leftLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBInspectable var leftLineWidth: CGFloat {
        get {
            return self.leftLineWidth
        }
        set {
            DispatchQueue.main.async {
                self.addLeftBorderWithColor(color: self.leftLineColor, width: newValue)
            }
        }
    }
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "topBorderLayer"
        removePreviouslyAddedLayer(name: border.name ?? "")
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y : 0,width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    //    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
    //        let border = CALayer()
    //        border.name = "rightBorderLayer"
    //        removePreviouslyAddedLayer(name: border.name ?? "")
    //        border.backgroundColor = color.cgColor
    //        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width : width, height :self.frame.size.height)
    //        self.layer.addSublayer(border)
    //    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "bottomBorderLayer"
        removePreviouslyAddedLayer(name: border.name ?? "")
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,width : self.frame.size.width,height: width)
        self.layer.addSublayer(border)
    }
    
    func setBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "bottomBorderLayer"
        removePreviouslyAddedLayer(name: border.name ?? "")
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,width : self.frame.size.width + 40,height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "leftBorderLayer"
        removePreviouslyAddedLayer(name: border.name ?? "")
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0,width : width, height : self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func removePreviouslyAddedLayer(name : String) {
        if self.layer.sublayers?.count ?? 0 > 0 {
            self.layer.sublayers?.forEach {
                if $0.name == name {
                    $0.removeFromSuperlayer()
                }
            }
        }
    }
    
    func blur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    func unBlur() {
        for subview in self.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
//    func fixInView(_ container: UIView!) -> Void{
//        self.translatesAutoresizingMaskIntoConstraints = false;
//        self.frame = container.frame;
//        container.addSubview(self);
//        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
//    }
    
    func setBottomBorder(_ isBackgroundGray: Bool = false, setDark: Bool = true) {
//        self.borderStyle = .none
        self.layer.backgroundColor = isBackgroundGray ? UIColor.AppLightestGray.cgColor : UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = setDark ? UIColor.AppLightestGray.withAlphaComponent(0.2).cgColor : UIColor.groupTableViewBackground.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        
        if let field = self as? UITextField {
            field.placeHolderColor = UIColor.colorFromHex("404852").withAlphaComponent(0.4)
        }
        
    }
}

extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: UIColor.AppLightestGray])
        }
    }
    
//    @IBInspectable var boldPlaceHolderColor: UIColor? {
//        get {
//            return self.boldPlaceHolderColor
//        }
//        set {
//            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: UIColor.AppLightGray, NSAttributedString.Key.font: UIFont.mainFont(ofSize: 16, family: .extraBold)])
//        }
//    }
    
    func isEmpty() -> Bool {
        let trimmedString = self.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        return trimmedString.isEmpty
    }
    
    func validate() -> Bool {
        let trimmedString = self.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        return !trimmedString.isEmpty
    }
    
    func setRightViewIcon(icon: UIImage) {
        let btnView = UIButton(frame: CGRect(x: 0, y: 0, width: ((self.frame.height) * 0.75), height: ((self.frame.height) * 0.50)))
        btnView.isUserInteractionEnabled = false
        btnView.setImage(icon, for: .normal)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
        self.rightViewMode = .always
        self.rightView = btnView
    }
    
    
    /// set icon of 20x20 with left padding of 8px
    func setLeftIcon(_ icon: UIImage, padding: CGFloat, size: CGFloat) {
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size + padding, height: size))
        let iconView  = UIImageView(frame: CGRect(x: padding / 2, y: 0, width: size, height: size))
        iconView.image = icon
        outerView.addSubview(iconView)
        iconView.tintColor = self.border_color
        leftView = outerView
        
        leftViewMode = .always
    }
    
    func setRightIcon(_ icon: UIImage, selectedIcon: UIImage, padding: CGFloat, size: CGFloat, rightIconAction: @escaping (_ sender: UIButton)->()) {
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size + padding, height: size))
        let iconView = UIButton(frame: CGRect(x: 0, y: 0, width: size, height: size))
        iconView.setImage(icon, for: .normal)
        iconView.setImage(selectedIcon, for: .selected)
      //  let iconView  = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        //outerView.backgroundColor = .red
     //   iconView.image = icon
        iconView.addAction(for: .touchUpInside) {
            iconView.isSelected.toggle()
            rightIconAction(iconView)
        }
        
        iconView.imageView?.contentMode = .scaleAspectFit
        outerView.addSubview(iconView)
      //  iconView.tintColor = self.border_color
        rightView = outerView
        
        rightViewMode = .always
    }
    
    func roundedCorner() {
        layer.cornerRadius = self.frame.height / 2
        layer.masksToBounds = true
    }
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    @objc func dismissKeyboard(){
        resignFirstResponder()
        endEditing(true)
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
//    @objc private func rightIconAction() {
//
//    }
}

extension UIControl {
    
    func addAction(for controlEvents: UIControl.Event, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
}


extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
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
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
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
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        return mapToDevice(identifier: identifier)
    }()
}

class ClosureSleeve {
    
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
    
}
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
import AVKit
extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            imageGenerator.appliesPreferredTrackTransform = true
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}
extension CLLocation {
    func placemark(completion: @escaping ( _ placemark: CLPlacemark?,  _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}

extension CLPlacemark {
    /// street name, eg. Infinite Loop
    var streetName: String? { thoroughfare }
    /// // eg. 1
    var streetNumber: String? { subThoroughfare }
    /// city, eg. Cupertino
    var city: String? { locality }
    /// neighborhood, common name, eg. Mission District
    var neighborhood: String? { subLocality }
    /// state, eg. CA
    var state: String? { administrativeArea }
    /// county, eg. Santa Clara
    var county: String? { subAdministrativeArea }
    /// zip code, eg. 95014
    var zipCode: String? { postalCode }
    /// postal address formatted
    @available(iOS 11.0, *)
    var postalAddressFormatted: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter().string(from: postalAddress)
    }
}
extension UITableView
{
    func indexPathExists(indexPath:IndexPath) -> Bool {
        if indexPath.section >= self.numberOfSections {
            return false
        }
        if indexPath.row >= self.numberOfRows(inSection: indexPath.section) {
            return false
        }
        return true
    }
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
extension UISwitch {
    func set(width: CGFloat, height: CGFloat) {
        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51
        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth
        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}
