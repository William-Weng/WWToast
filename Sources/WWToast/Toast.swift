//
//  WWToast.swift
//  WWToast
//
//  Created by William.Weng on 2023/02/22.
//  file:///Users/ios/Desktop/WWToast

import UIKit
import WWPrint

// MARK: - WWToastDelegate
public protocol WWToastDelegate: AnyObject {
    
    func willDisplay(window: WWToastWindow?, textList: [String], text: String?)
    func didDisplay(window: WWToastWindow?, textList: [String], text: String?)
    func willDismiss(window: WWToastWindow?, textList: [String], text: String?)
    func didDismiss(window: WWToastWindow?, textList: [String], text: String?)
}

// MARK: - WWToast
open class WWToast {
    
    public static let shared = WWToastWindow.build()
    private init() {}
}

// MARK: - WWToastWindow
public class WWToastWindow: UIWindow {
    
    static private var level = Level.alert + 1000
    static private var font = UIFont.systemFont(ofSize: 20.0)
    
    weak public var delegate: WWToastDelegate?
    
    static func build() -> WWToastWindow {
        
        guard let scenen = UIWindowScene._connected(),
              let viewController = UIStoryboard._instantiateViewController(name: "Main", bundle: Bundle.module, identifier: String(describing: WWToastViewController.self)) as? WWToastViewController
        else {
            fatalError()
        }
        
        let window = WWToastWindow(frame: .zero)
        
        window._windowScene(scene: scenen)
              ._backgroundColor(.clear)
              ._windowLevel(Self.level)
              ._rootViewController(viewController)
              ._makeKeyAndVisible()
        
        return window
    }
}

// MARK: - WWToastWindow (public class function)
public extension WWToastWindow {
    
    /// [顯示文字](https://givemepass.blogspot.com/2019/04/toastmd.html)
    /// - Parameters:
    ///   - target: 要顯示的UIViewController
    ///   - text: 顯示的文字
    ///   - duration: 顯示的時間
    ///   - backgroundColor: 背景色
    ///   - textColor: 文字顏色
    ///   - height: 與底部的相差高度
    func makeText<T>(target: UIViewController, text: T, duration: WWToastViewController.ToastLength = .middle, backgroundColor: UIColor = .darkGray, textColor: UIColor = .white, height: CGFloat = 64.0) {
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
    func makeText<T>(targetFrame: CGRect, text: T, duration: WWToastViewController.ToastLength = .middle, backgroundColor: UIColor = .darkGray, textColor: UIColor = .white, height: CGFloat = 64.0) {
        
        guard let viewController = self.rootViewController as? WWToastViewController else { return }
        
        viewController.delegate = delegate
        viewController.makeText(targetFrame: targetFrame, text: text, duration: duration, backgroundColor: backgroundColor, textColor: textColor, height: height)
    }
}
