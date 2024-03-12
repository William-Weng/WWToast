//
//  WWToastViewController.swift
//  WWToast
//
//  Created by William.Weng on 2023/2/22.
//

import UIKit
import WWPrint

// MARK: - WWToastViewController
public class WWToastViewController: UIViewController {
    
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
    private var textList: [String] = []
    
    weak var delegate: WWToastDelegate?
}

// MARK: - WWToastViewController (function)
extension WWToastViewController {
    
    /// 顯示文字
    /// - Parameters:
    ///   - text: 文字
    ///   - duration: 時間
    func makeText<T>(targetFrame: CGRect, text: T, duration: WWToastViewController.ToastLength = .middle, backgroundColor: UIColor = .darkGray, textColor: UIColor = .white, height: CGFloat = 64.0) {
        
        var deadline: DispatchTime = .now()
        
        if (previousDeadline < deadline) { previousDeadline = deadline }
        
        if (!textList.isEmpty) {
            deadline = previousDeadline + duration.rawValue
        } else {
            deadline = previousDeadline + 0
        }
        
        previousDeadline = deadline
        textList.append("\(text)")
        
        let window = view.window as? WWToastWindow
                
        delegate?.willDisplay(window: window, textList: textList, text: textList.last)
        
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            
            guard let this = self else { return }
            
            let runningDuration = duration.rawValue * 0.5
            let lines = this.toastWindowSetting(targetFrame: targetFrame, text: text, height: height)
            
            this.toastViewControllerSetting(text, lines: lines, backgroundColor: backgroundColor)
            this.backgroundView.alpha = 0.0
            this.view.window?.isHidden = false

            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: runningDuration, delay: 0, options: [.curveEaseInOut], animations: {
                
                this.backgroundView.alpha = 1.0

            }, completion: { _ in
                
                this.delegate?.didDisplay(window: window, textList: this.textList, text: this.textList.last)
                
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: runningDuration, delay: 0, options: [.curveEaseInOut], animations: {
                    
                    this.backgroundView.alpha = 0.0
                    this.delegate?.willDismiss(window: window, textList: this.textList, text: this.textList.last)

                }, completion: { _ in
                    this.view.window?.isHidden = true
                    _ = this.textList.popLast()
                    this.delegate?.didDismiss(window: window, textList: this.textList, text: this.textList.last)
                })
            })
        }
    }
}

// MARK: - WWToastViewController (function)
private extension WWToastViewController {
    
    /// ToastWindow的大小寬高設定 (行數)
    /// - Parameters:
    ///   - targetFrame: 要顯示的Frame
    ///   - text: 顯示的文字
    ///   - height: 與底部的相差高度
    /// - Returns: 顯示的行數
    func toastWindowSetting<T>(targetFrame: CGRect, text: T, height: CGFloat = 64.0) -> Int {
        
        guard let keyWindow = self.view.window as? WWToastWindow else { fatalError() }
        
        let gap = (width: 36.0, height: 8.0)
        let maxWidth = targetFrame.width - gap.width * 2
        let textSize = UILabel._textSizeThatFits(with: "\(text)", font: font)
        
        var lines = 1
        var fixTextSize = CGSize(width: textSize.width + gap.width, height: textSize.height + gap.height)

        if (textSize.width > maxWidth) {
            lines = Int(textSize.width / maxWidth) + 1
            fixTextSize = CGSize(width: maxWidth, height: CGFloat(lines) * (textSize.height + gap.height))
        }
        
        keyWindow.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        keyWindow.frame = CGRect(origin: .zero, size: fixTextSize)
        keyWindow.center = CGPoint(x: targetFrame.width * 0.5, y: targetFrame.height - height)
        
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
    func toastViewControllerSetting<T>(_ text: T, lines: Int, duration: WWToastViewController.ToastLength = .middle, backgroundColor: UIColor = .darkGray, textColor: UIColor = .white) {
        
        self.backgroundView.alpha = 0.0
        self.backgroundView.backgroundColor = backgroundColor
        
        self.messageLabel.font = font
        self.messageLabel.text = "\(text)"
        self.messageLabel.textColor = textColor
        self.messageLabel.textAlignment = (lines > 1) ? .left : .center
    }
}
