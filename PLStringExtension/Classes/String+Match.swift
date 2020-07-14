//
//  String+Match.swift
//  CryptoSwift
//
//  Created by 彭磊 on 2020/7/14.
//

import UIKit

public extension String {
    /// 字符串的匹配范围
    ///
    /// - Parameters:
    ///     - matchStr: 要匹配的字符串
    /// - Returns: 返回所有字符串范围
    @discardableResult
    func plMatchStrRange(_ matchStr: String) -> [NSRange] {
        var selfStr = self as NSString
        var withStr = Array(repeating: "X", count: (matchStr as NSString).length).joined(separator: "") //辅助字符串
        if matchStr == withStr { withStr = withStr.lowercased() } //临时处理辅助字符串差错
        var allRange = [NSRange]()
        while selfStr.range(of: matchStr).location != NSNotFound {
            let range = selfStr.range(of: matchStr)
            allRange.append(NSRange(location: range.location, length: range.length))
            let inRange = NSRange.init(location: range.location, length: range.length)
            selfStr = selfStr.replacingCharacters(in: inRange, with: withStr) as NSString
        }
        return allRange
    }
}
