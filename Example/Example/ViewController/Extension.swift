//
//  Extension.swift
//  Example
//
//  Created by William.Weng on 2024/12/4.
//

import UIKit

// MARK: - UIColor (static function)
extension UIColor {
    
    /// 隨機顏色
    /// - Returns: UIColor
    static func _random() -> UIColor { return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)}
}
