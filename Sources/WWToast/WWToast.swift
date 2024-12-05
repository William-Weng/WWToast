//
//  WWToast.swift
//  WWToast
//
//  Created by William.Weng on 2023/02/22.
//

import UIKit

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
    
    /// 建立WWToastWindow
    /// - Returns: WWToastWindow
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
    func makeText<T>(target: UIViewController, text: T) {
        makeText(text, targetFrame: target.view.frame)
    }
    
    /// [顯示文字](https://ithelp.ithome.com.tw/articles/10241214)
    /// - Parameters:
    ///   - targetFrame: 要顯示的最大Frame
    ///   - text: 顯示的文字
    func makeText<T>(_ text: T, targetFrame: CGRect = UIScreen.main.bounds) {
        
        guard let viewController = self.rootViewController as? WWToastViewController else { return }
        
        viewController.delegate = delegate
        viewController.makeText(text, targetFrame: targetFrame)
    }
    
    /// 相關設定
    /// - Parameters:
    ///   - backgroundViewColor: 顯示框背景色
    ///   - textColor: 文字顏字
    ///   - toastLength: 顯示框的顯示時間
    ///   - bottomHeight: 與底部的相差高度
    ///   - animationOptions: 動畫參數
    func setting(backgroundViewColor: UIColor, textColor: UIColor? = nil, toastLength: Constant.ToastLength? = nil, bottomHeight: CGFloat? = nil, animationOptions: UIView.AnimationOptions? = nil) {
        
        guard let viewController = self.rootViewController as? WWToastViewController else { return }
        
        viewController.setting(backgroundViewColor: backgroundViewColor, textColor: textColor, toastLength: toastLength, bottomHeight: bottomHeight, animationOptions: animationOptions)
    }
}
