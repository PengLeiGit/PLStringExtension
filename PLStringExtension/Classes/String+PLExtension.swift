//
//  String+PLExtension.swift
//  PLStringExtension
//
//  Created by 彭磊 on 2020/7/13.
//

import UIKit
import PLOptionalExtension
import CryptoSwift

/// MARK:  计算Size
public extension String {
    
    func sizeWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGSize {
        return sizeWithAttributes(width, attributes: [NSAttributedString.Key.font: font])
    }
    
    func ss_size(withFont font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        return (self as NSString).size(withAttributes: attributes)
    }
    
    func sizeWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        return size(constraintRect, attributes: [NSAttributedString.Key.font: font])
    }
    
    func sizeWithAttributes(_ width: CGFloat, attributes: [NSAttributedString.Key: Any]?) -> CGSize {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        return size(constraintRect, attributes: attributes)
    }
    
    private func size(_ size: CGSize, attributes: [NSAttributedString.Key: Any]?) -> CGSize {
        let boundingBox = self.boundingRect(with: size,
                                            options: NSStringDrawingOptions([.usesLineFragmentOrigin, .usesFontLeading]),
                                            attributes: attributes,
                                            context: nil)
        
        return boundingBox.size
    }
}


/// MARK:  基础设置
public extension String {
    
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
    
    var htmlAtributedString: NSAttributedString {
        guard let data = self.data(using: .utf8) else { return NSAttributedString() }
        do {
            let attributedString = try NSAttributedString(data: data,
                                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                                          documentAttributes: nil)
            return attributedString
        } catch {
            return NSAttributedString()
        }
    }
    
    func isNumber() -> Bool {
        return !self.isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func isContainNumber() -> Bool {
        if self.isEmpty { return false }
        do {
            let numberRegular = try NSRegularExpression(pattern: "[0-9]", options: NSRegularExpression.Options.caseInsensitive)
            let tNumberMatchCount = numberRegular.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: self.count))
            if tNumberMatchCount > 0 {
                return true
            }
        } catch {}
        return false
    }
    
    func isContainLetter() -> Bool {
        if self.isEmpty { return false }
        do {
            let letterRegular = try NSRegularExpression(pattern: "[A-Za-z]", options: NSRegularExpression.Options.caseInsensitive)
            let tletterMatchCount = letterRegular.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: self.count))
            if tletterMatchCount > 0 {
                return true
            }
        } catch {}
        return false
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        return Range(nsRange, in: self)
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    /// 字符串截取，获取结果为[0, index)
    func subStringClip(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    /// 字符串截取，获取结果为(index, self.count]
    func subStringClip(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
    
    func nsRanges(of string: String) -> [NSRange] {
        var rangeArray = [NSRange]()
        var searchedRange: Range<String.Index>
        guard let sr = self.range(of: self) else { return rangeArray }
        searchedRange = sr
        var resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        while let range = resultRange {
            rangeArray.append(NSRange.init(range, in: self))
            searchedRange = Range(uncheckedBounds: (range.upperBound, searchedRange.upperBound))
            resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        }
        return rangeArray
    }
    
    /// 过滤回车换行
    func filterLineCharacter() -> String {
        let str = self.trimmingCharacters(in: .whitespacesAndNewlines)
        var tempArray = str.components(separatedBy: .whitespacesAndNewlines)
        tempArray = tempArray.filter { (item) -> Bool in
            return item != ""
        }
        return tempArray.joined()
        //        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func stringWithClipMaxWidth(_ width: CGFloat, font: UIFont) -> String {
        var newStr = ""
        var i = 1
        while i <= self.count {
            let subString = (self as NSString).substring(with: NSRange(location: 0, length: i))
            let size = subString.sizeWithConstrainedWidth(10000, font: font)
            if size.width > width {
                break
            }
            i += 1
            newStr = subString
        }
        return newStr
    }
}


// MARK: - -字符串转 float int
public extension String {
    
    func changeToCGFloat() -> CGFloat {
        if self.count <= 0 {
            return 0
        }
        let str = self.pregReplace(pattern: "[^\\d.]+", with: "")
        return CGFloat(Double(str).or(0.0))
    }
    
    func changeToInt() -> Int {
        if self.count <= 0 {
            return 0
        }
        let str = self.pregReplace(pattern: "[^\\d]+", with: "")
        return Int(str)!
    }
    
    init(moreThanTenThousand value: CGFloat) {
        if value >= 10000 {
            self.init(format: "%.1f万", value / 10000)
        } else {
            self.init(format: "%.0f", value)
        }
    }
    
    //使用正则表达式替换
    func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSRange(location: 0, length: self.count),
                                              withTemplate: with)
    }
    
}


public extension String {
    
    /// 返回属性字符串
    ///
    /// - Parameters:
    /// - font: UIFont
    ///   - kerning: 字距
    ///   - spacing: 行间距
    ///   - breakMode: 断尾方式
    /// - Returns: 属性字符串
    func attributeString(_ font: UIFont, kerning: CGFloat = 0, spacing: CGFloat = 0, breakMode: NSLineBreakMode? = .byCharWrapping) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing // 行间距
        style.lineBreakMode = breakMode != nil ? breakMode! : .byCharWrapping
        let text = NSMutableAttributedString(string: self, attributes: [.font: font,
                                                                        NSAttributedString.Key.paragraphStyle: style,
                                                                        NSAttributedString.Key.kern: kerning])
        return text
    }
    
    /// 返回属性字符串
    ///
    /// - Parameters:
    ///   - font:  字体大小
    ///   - spacing: 行间距
    ///   - breakMode: break mode
    /// - Returns: attribute str
    func mutableAttributeString(_ font: UIFont, kerning: CGFloat = 0, spacing: CGFloat = 0, breakMode: NSLineBreakMode?, textColor: UIColor? = UIColor.black) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        style.lineBreakMode = breakMode != nil ? breakMode! : .byCharWrapping
        let text = NSMutableAttributedString(string: self, attributes: [.font: font, NSAttributedString.Key.paragraphStyle: style])
        if let color = textColor {
            text.addAttributes([.foregroundColor: color], range: NSRange.init(location: 0, length: self.count))
        }
        
        return text
    }
}

public extension StringProtocol {

    /// 首字母大写
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }

    /// 首字母小写
    var firstLowercased: String {
        return prefix(1).lowercased() + dropFirst()
    }

}

// validate
public extension String {
    var isValidEmail: Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

public extension String {
    static func generateUUID() -> String {
        return UUID().uuidString.uppercased().md5()
    }
}

public extension String {
    func transformToPinyin() -> String {
        let stringRef = NSMutableString(string: self) as CFMutableString
        // 转换为带音标的拼音
        CFStringTransform(stringRef, nil, kCFStringTransformMandarinLatin, false)
        // 去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripDiacritics, false)
        let pinyin = stringRef as String
        return pinyin
    }
    
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F,   // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            0x1F1E6...0x1F1FF: // Flags
                return true
            default:
                continue
            }
        }
        return false
    }
}


public extension String {
    func rangeOf(sub string: String) -> NSRange {
        if let range = self.range(of: string) {
            let nsrange = NSRange(range, in: self)
            return nsrange
        }
        return NSRange(location: 0, length: 0)
    }
    
    //多个子字符串相同时 可以返回第一个或者最后一个字符串位置
    func rangeOfStartOrEnd(sub string: String, isLast: Bool = true) -> NSRange {
        var pos = -1
        if let range = range(of: string, options: isLast ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from: startIndex, to: range.lowerBound)
            }
        }
        return NSRange(location: pos, length: string.count)
    }
}

