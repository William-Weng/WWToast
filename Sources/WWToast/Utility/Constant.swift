//
//  Constant.swift
//  WWToast
//
//  Created by William.Weng on 2023/2/22.
//

import Foundation

// MARK: - 常數
public class Constant {}

// MARK: - enum
public extension Constant {
    
    // MARK: - 顯示的時間
    enum ToastLength {
        
        case short
        case middle
        case long
        case custom(_ time: TimeInterval)
        
        /// 轉換成時間
        /// - Returns: TimeInterval
        func timeInterval() -> TimeInterval {
            
            switch self {
            case .short: return 2.0
            case .middle: return 4.0
            case .long: return 6.0
            case .custom(let timeInterval): return timeInterval
            }
        }
    }
    
    // MARK: - 顯示框的狀態
    enum DisplayStatus {
        
        case willDisplay
        case didDisplay
        case willDismiss
        case didDismiss
    }
}
