//
//  ToastViewController.swift
//  
//
//  Created by iOS on 2023/2/22.
//

import UIKit
import WWPrint

// MARK: - ToastViewController
public class ToastViewController: UIViewController {
    
    // MARK: - 顯示的時間
    public enum ToastLength: TimeInterval {
        case short = 2.0
        case middle = 4.0
        case long = 6.0
    }
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private let font = UIFont.systemFont(ofSize: 20.0)
    private var previousDeadline: DispatchTime = .now()
}

// MARK: - ToastViewController (class function)
extension ToastViewController {
    
    /// 顯示文字
    /// - Parameters:
    ///   - text: 文字
    ///   - duration: 時間
    func makeText<T>(target: UIViewController, text: T, duration: ToastViewController.ToastLength = .middle, backgroundColor: UIColor = .darkGray, textColor: UIColor = .white, height: CGFloat = 64.0) {
        
        var deadline: DispatchTime = .now()
        
        if (previousDeadline < deadline) { previousDeadline = deadline }
        
        deadline = previousDeadline + duration.rawValue
        previousDeadline = deadline
        
        wwPrint(text)
        
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            
            guard let this = self else { return }
            
            let runningDuration = duration.rawValue * 0.5
            let lines = this.toastWindowSetting(target: target, text: text)
            
            this.toastViewControllerSetting(text, lines: lines)
            this.backgroundView.alpha = 0.0
            this.messageLabel.text = "\(text)"
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: runningDuration, delay: 0, options: [.curveEaseInOut], animations: {
                this.backgroundView.alpha = 1.0
            }, completion: { _ in
                this.backgroundView.alpha = 1.0
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: runningDuration, delay: 0, options: [.curveEaseInOut], animations: {
                    this.backgroundView.alpha = 0.0
                }, completion: { _ in
                })
            })
        }
    }
}

// MARK: - ToastWindow (class function)
private extension ToastViewController {
    
    /// ToastWindow的大小寬高設定
    /// - Parameters:
    ///   - target: 要顯示的UIViewController
    ///   - text: 顯示的文字
    ///   - height: 與底部的相差高度
    /// - Returns: 顯示的行數
    func toastWindowSetting<T>(target: UIViewController, text: T, height: CGFloat = 64.0) -> Int {
        
        guard let keyWindow = self.view.window as? ToastWindow else { fatalError() }
        
        let gap = (width: 36.0, height: 8.0)
        let maxWidth = target.view.frame.width - gap.width * 2
        let textSize = UILabel._textSizeThatFits(with: "\(text)", font: font)
        
        var lines = 1
        var fixTextSize = CGSize(width: textSize.width + gap.width, height: textSize.height + gap.height)

        if (textSize.width > maxWidth) {
            lines = Int(textSize.width / maxWidth) + 1
            fixTextSize = CGSize(width: maxWidth, height: CGFloat(lines) * (textSize.height + gap.height))
        }
        
        keyWindow.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        keyWindow.frame = CGRect(origin: .zero, size: fixTextSize)
        keyWindow.center = CGPoint(x: target.view.frame.width * 0.5, y: target.view.frame.height - height)
        
        return lines
    }
    
    /// 設定顯示
    /// - Parameters:
    ///   - viewController: ToastViewController
    ///   - text: 顯示的文字
    ///   - lines: 顯示的行數
    ///   - duration: 顯示時間
    ///   - backgroundColor: 背景顏色
    ///   - textColor: 文字顏色
    func toastViewControllerSetting<T>(_ text: T, lines: Int, duration: ToastViewController.ToastLength = .middle, backgroundColor: UIColor = .darkGray, textColor: UIColor = .white) {
        
        self.backgroundView.alpha = 0.0
        self.backgroundView.backgroundColor = backgroundColor
        
        self.messageLabel.font = font
        self.messageLabel.text = ""
        self.messageLabel.textColor = textColor
        self.messageLabel.textAlignment = (lines > 1) ? .left : .center
    }
}
