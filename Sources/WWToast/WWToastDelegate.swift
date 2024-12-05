//
//  WWToastDelegate.swift
//  WWToast
//
//  Created by William.Weng on 2024/12/5.
//

import UIKit

// MARK: - WWToastDelegate
public protocol WWToastDelegate: AnyObject {
    
    /// 文字框顯示的狀態
    /// - Parameters:
    ///   - window: WWToastWindow?
    ///   - textQueue: 文字佇列
    ///   - text: 要顯示的文字
    func toastDisplay(_ window: WWToastWindow?, textQueue: [String], text: String?, status: Constant.DisplayStatus)
}
