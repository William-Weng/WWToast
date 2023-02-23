//
//  Extension.swift
//  WWToast
//
//  Created by William.Weng on 2023/2/22.
//

import UIKit

// MARK: - UIStoryboard (static function)
extension UIStoryboard {
    
    /// 由UIStoryboard => ViewController
    /// - Parameters:
    ///   - name: Storyboard的名稱 => Main.storyboard
    ///   - storyboardBundleOrNil: Bundle名稱
    ///   - identifier: ViewController的代號 (記得要寫)
    /// - Returns: T (泛型) => UIViewController
    static func _instantiateViewController<T: UIViewController>(name: String = "Main", bundle storyboardBundleOrNil: Bundle? = nil, identifier: String = String(describing: T.self)) -> T {
        
        let viewController = Self(name: name, bundle: storyboardBundleOrNil).instantiateViewController(identifier: identifier) as T
        return viewController
    }
}

// MARK: - UIWindowScene (static function)
extension UIWindowScene {
    
    /// 取得第一個連接到的UIWindowScene
    /// - Returns: UIWindowScene
    static func _connected() -> UIWindowScene? {
        return UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
}

// MARK: - UIWindow (static function)
extension UIWindow {
    
    /// 建立UIWindow
    /// - Parameters:
    ///   - rootViewController: UIViewController
    ///   - alpha: CGFloat
    ///   - windowLevel: UIWindow.Level
    ///   - backgroundColor: UIColor?
    /// - Returns: UIWindow?
    static func _build(rootViewController: UIViewController, alpha: CGFloat = 1.0, windowLevel: UIWindow.Level = .alert, backgroundColor: UIColor? = nil) -> UIWindow? {
        guard let scene = UIWindowScene._connected() else { return nil }
        return Self._build(scene: scene, rootViewController: rootViewController, alpha: alpha, windowLevel: windowLevel, backgroundColor: backgroundColor)
    }
    
    /// 建立UIWindow
    /// - Parameters:
    ///   - scene: UIWindowScene
    ///   - rootViewController: UIViewController
    ///   - alpha: CGFloat
    ///   - windowLevel: UIWindow.Level
    ///   - backgroundColor: UIColor?
    /// - Returns: UIWindow
    static func _build(scene: UIWindowScene, rootViewController: UIViewController, alpha: CGFloat = 1.0, windowLevel: UIWindow.Level = .alert, backgroundColor: UIColor? = nil) -> UIWindow {
        let newWindow = UIWindow(windowScene: scene)._alpha(alpha)._windowLevel(windowLevel)._backgroundColor(backgroundColor)._rootViewController(rootViewController)
        return newWindow
    }
}

// MARK: - UIWindow (class function)
extension UIWindow {
    
    /// 設定透明色
    /// - Parameter alpha: CGFloat
    /// - Returns: Self
    func _alpha(_ alpha: CGFloat) -> Self { self.alpha = alpha; return self }
    
    /// 設定背景色
    /// - Parameter color: UIColor
    /// - Returns: Self
    func _backgroundColor(_ color: UIColor?) -> Self { self.backgroundColor = color; return self }
    
    /// 設定Window的等級 => 越大越上層
    /// - Parameter level: UIWindow.Level
    /// - Returns: Self
    func _windowLevel(_ level: UIWindow.Level) -> Self { self.windowLevel = level; return self }
    
    /// 設定第一個ViewController
    /// - Parameter rootViewController: UIViewController
    /// - Returns: Self
    func _rootViewController(_ rootViewController: UIViewController?) -> Self { self.rootViewController = rootViewController; return self }
    
    /// 設定放在哪一個UIWindowScene上
    /// - Parameter scene: UIWindowScene
    func _windowScene(scene: UIWindowScene) -> Self { self.windowScene = scene; return self }
    
    /// 設定為KeyWindow
    func _makeKey() { self.makeKey() }
    
    /// 設定為KeyWindow + 使用它
    func _makeKeyAndVisible() { self.makeKeyAndVisible() }
}

// MARK: - UILabel (static function)
extension UILabel {
    
    /// 計算滿版Label文字的寬度 + 高度
    ///  - 單行 / 自訂字型
    /// - Parameters:
    ///   - text: 字串
    ///   - font: 字型
    ///   - lines: 要幾行
    /// - Returns: CGSize
    static func _textSizeThatFits(with text: String, font: UIFont, numberOfLines lines: Int = 1) -> CGSize {
        
        let label = UILabel()
        
        label.text = text
        label.font = font
        label.adjustsFontSizeToFitWidth = false
        label.numberOfLines = lines
        
        return label.sizeThatFits(.zero)
    }
}
