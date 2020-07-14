//
//  Optional+Extension.swift
//  PLOptionalExtension
//
//  Created by 彭磊 on 2020/7/14.
//

import Foundation

public extension Optional {
    /// 判断是否为nil，为nil返回true
    var isNone: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }
    
    /// 判断是否有值，有值返回true
    var isSome: Bool {
        switch self {
        case .some:
            return true
        case .none:
            return false
        }
    }
    
    /// 取值时，设置默认值
    ///
    /// - Parameter default: 默认值
    /// - Returns: 取值
    func or(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }
    
    /// 取值时，如果为nil，设置闭包返回默认值
    ///
    /// - Parameter else: 闭包返回默认值
    /// - Returns: 取值
    func or(else: @autoclosure () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }
    
    func map<U>(_ transform: (Wrapped) throws -> U, default: U) rethrows -> U {
        return try map(transform) ?? `default`
    }
    
    func map<U>(transform: (Wrapped) throws -> U, default: @autoclosure () throws -> U) rethrows -> U {
        return try map(transform) ?? `default`()
    }
    
    func flatMap<U>(_ transform: (Wrapped) throws -> U?, default: U) rethrows -> U {
        return try flatMap(transform) ?? `default`
    }
    
    func flatMap<U>(transform: (Wrapped) throws -> U?, default: @autoclosure () throws -> U) rethrows -> U {
        return try flatMap(transform) ?? `default`()
    }
}
