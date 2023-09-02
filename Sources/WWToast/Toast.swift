//
//  Toast.swift
//  WWToast
//
//  Created by William.Weng on 2023/02/22.
//  file:///Users/ios/Desktop/WWToast

import UIKit
import WWPrint

// MARK: - WWToast
open class WWToast {
    
    public static let shared = ToastWindow.build()
    private init() {}
}

// MARK: - ToastWindow
public class ToastWindow: UIWindow {
    
    static private var level = Level.alert + 1000
    static private var font = UIFont.systemFont(ofSize: 20.0)
    
    static func build() -> ToastWindow {
        
        guard let scenen = UIWindowScene._connected(),
              let viewController = UIStoryboard._instantiateViewController(name: "Main", bundle: Bundle.module, identifier: String(describing: ToastViewController.self)) as? ToastViewController
        else {
            fatalError()
        }
        
        let window = ToastWindow(frame: .zero)
        
        window._windowScene(scene: scenen)
              ._backgroundColor(.clear)
              ._windowLevel(Self.level)
              ._rootViewController(viewController)
              ._makeKeyAndVisible()
        
        return window
    }
}

// MARK: - ToastWindow (public class function)
public extension ToastWindow {
    
    /// [顯示文字](https://givemepass.blogspot.com/2019/04/toastmd.html)
    /// - Parameters:
    ///   - target: 要顯示的UIViewController
    ///   - text: 顯示的文字
    ///   - duration: 顯示的時間
    ///   - backgroundColor: 背景色
    ///   - textColor: 文字顏色
    ///   - height: 與底部的相差高度
    func makeText<T>(target: UIViewController, text: T, duration: ToastViewController.ToastLength = .middle, backgroundColor: UIColor = .darkGray, textColor: UIColor = .white, height: CGFloat = 64.0) {
        makeText(targetFrame: target.view.frame, text: text, duration: duration, backgroundColor: backgroundColor, textColor: textColor, height: height)
    }
    
    /// [顯示文字](https://ithelp.ithome.com.tw/articles/10241214)
    /// - Parameters:
    ///   - targetFrame: 要顯示View的Frame
    ///   - text: 顯示的文字
    ///   - duration: 顯示的時間
    ///   - backgroundColor: 背景色
    ///   - textColor: 文字顏色
    ///   - height: 與底部的相差高度
    func makeText<T>(targetFrame: CGRect, text: T, duration: ToastViewController.ToastLength = .middle, backgroundColor: UIColor = .darkGray, textColor: UIColor = .white, height: CGFloat = 64.0) {
        
        guard let viewController = self.rootViewController as? ToastViewController else { return }
        viewController.makeText(targetFrame: targetFrame, text: text, duration: duration, backgroundColor: backgroundColor, textColor: textColor, height: height)
    }
}
