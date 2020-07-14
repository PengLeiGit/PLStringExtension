//
//  String+NSAttributedString.swift
//  PLStringExtension
//
//  Created by 彭磊 on 2020/7/13.
//

import UIKit

public extension String {
    /// 整体区间
    var pl_range: NSRange {
        return NSRange(location: 0, length: count)
    }
    
    /// 添加 NSAttributedString.Key.font
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - range: 区间
    /// - Returns: NSMutableAttributedString
    func du_font(_ font: UIFont, range: NSRange? = nil) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: self)
        var ran = pl_range
        if let r = range {
            ran = NSIntersectionRange(ran, r)
        }
        attr.addAttribute(.font, value: font, range: ran)
        return attr
    }
    
    /// 添加 NSAttributedString.Key.foregroundColor 字体颜色
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - range: 区间
    /// - Returns: NSMutableAttributedString
    func du_textColor(_ color: UIColor, range: NSRange? = nil) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: self)
        var ran = pl_range
        if let r = range {
            ran = NSIntersectionRange(ran, r)
        }
        attr.addAttribute(.foregroundColor, value: color, range: ran)
        return attr
    }
    
    /// 添加 NSAttributedString.Key.kern  字符间距
    ///
    /// - Parameters:
    ///   - kern: 间距，默认为0 禁用
    ///   - range: 区间
    /// - Returns: NSMutableAttributedString
    func du_kern(_ kern: CGFloat, range: NSRange? = nil) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: self)
        var ran = pl_range
        if let r = range {
            ran = NSIntersectionRange(ran, r)
        }
        attr.addAttribute(.kern, value: kern, range: ran)
        return attr
    }
    
    /// 添加 NSAttributedString.Key.paragraphStyle  行距，断尾模式
    ///
    /// - Parameters:
    ///   - spacing: 行间距
    ///   - breakMode: break mode 断尾模式
    ///   - range: 区间
    /// - Returns: NSMutableAttributedString
    func du_paragraphStyle(style: NSMutableParagraphStyle, range: NSRange? = nil) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: self)
        var ran = pl_range
        if let r = range {
            ran = NSIntersectionRange(ran, r)
        }
        attr.addAttribute(.paragraphStyle, value: style, range: ran)
        return attr
    }
    
    /// 快捷转成 font，color 的 NSMutableAttributedString
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - color: 字颜色
    ///   - range: 区间
    /// - Returns: NSMutableAttributedString
    func du_fontAndColor(_ font: UIFont, color: UIColor, range: NSRange? = nil) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: self)
        var ran = pl_range
        if let r = range {
            ran = NSIntersectionRange(ran, r)
        }
        attr.addAttributes([.font: font, .foregroundColor: color], range: ran)
        return attr
    }
    
    /// 设置 baselineOffset
    ///
    /// - Parameters:
    ///   - offset: baselineOffset
    ///   - range: 区间
    /// - Returns: NSMutableAttributedString
    func du_baselineOffset(_ offset: CGFloat, range: NSRange? = nil) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: self)
        var ran = pl_range
        if let r = range {
            ran = NSIntersectionRange(ran, r)
        }
        attr.addAttribute(.baselineOffset, value: offset, range: ran)
        return attr
    }
    
    /// 分数字体格式
    ///
    /// - Parameters:
    ///   - font: 整体字体
    ///   - fractionFont: 分数字体
    /// - Returns: NSAttributedString
    func fractionAttributedString(font: UIFont, fractionFont: UIFont) -> NSAttributedString {
        let attribute = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: font])
        if let rangeIndex = self.rangeOfCharacter(from: CharacterSet(charactersIn: "⅓")) {
            attribute.addAttributes([NSAttributedString.Key.font: fractionFont], range: self.nsRange(from: rangeIndex))
        } else if let rangeIndex = self.rangeOfCharacter(from: CharacterSet(charactersIn: "⅔")) {
            attribute.addAttributes([NSAttributedString.Key.font: fractionFont], range: self.nsRange(from: rangeIndex))
        } else if let rangeIndex = self.rangeOfCharacter(from: CharacterSet(charactersIn: "½")) {
            attribute.addAttributes([NSAttributedString.Key.font: fractionFont], range: self.nsRange(from: rangeIndex))
        }
        return attribute
    }
}
