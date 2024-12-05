//
//  WWToastViewController.swift
//  WWToast
//
//  Created by William.Weng on 2023/2/22.
//

import UIKit

// MARK: - WWToastViewController
public class WWToastViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private let labelFont = UIFont.systemFont(ofSize: 20.0)
    
    private var textQueue: [String] = []
    private var isDisplaing = false
    
    private var backgroundViewColor: UIColor = .darkText
    private var textColor: UIColor = .white
    private var toastLength: Constant.ToastLength = .middle
    private var bottomHeight: CGFloat = 64.0
    private var animationOptions: UIView.AnimationOptions = [.curveEaseInOut]
    
    weak var delegate: WWToastDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setting(backgroundViewColor: .darkText, textColor: .white, toastLength: .middle, bottomHeight: 64.0, animationOptions: [.curveEaseInOut])
    }
}

// MARK: - WWToastViewController (function)
extension WWToastViewController {
    
    /// 相關設定
    /// - Parameters:
    ///   - backgroundViewColor: 顯示框背景色
    ///   - textColor: 文字顏字
    ///   - toastLength: 顯示框的顯示時間
    ///   - bottomHeight: 與底部的相差高度
    ///   - animationOptions: 動畫參數
    func setting(backgroundViewColor: UIColor?, textColor: UIColor?, toastLength: Constant.ToastLength?, bottomHeight: CGFloat?, animationOptions: UIView.AnimationOptions?) {
        
        self.backgroundViewColor = backgroundViewColor ?? self.backgroundViewColor
        self.textColor = textColor ?? self.textColor
        self.toastLength = toastLength ?? self.toastLength
        self.bottomHeight = bottomHeight ?? self.bottomHeight
        self.animationOptions = animationOptions ?? self.animationOptions
    }
    
    /// 顯示文字框
    /// - Parameters:
    ///   - text: 文字
    ///   - targetFrame: 文字框最大的Frame
    func makeText<T>(_ text: T, targetFrame: CGRect) {
        
        let window = view.window as? WWToastWindow
        
        textQueue.append("\(text)")
        delegate?.toastDisplay(window, textQueue: textQueue, text: textQueue.last, status: .willDisplay)
        
        displayText(targetFrame: targetFrame, duration: toastLength, backgroundViewColor: backgroundViewColor, textColor: textColor, height: bottomHeight, options: animationOptions)
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
    func toastWindowLineCount<T>(targetFrame: CGRect, text: T, height: CGFloat) -> Int {
        
        guard let keyWindow = self.view.window as? WWToastWindow else { fatalError() }
        
        let gap = (width: 36.0, height: 8.0)
        let maxWidth = targetFrame.width - gap.width * 2
        let textSize = UILabel._textSizeThatFits(with: "\(text)", font: labelFont)
        
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
    func toastViewControllerSetting<T>(_ text: T, lines: Int, duration: Constant.ToastLength, backgroundViewColor: UIColor, textColor: UIColor) {
        
        self.backgroundView.alpha = 0.0
        self.backgroundView.backgroundColor = backgroundViewColor
        
        self.messageLabel.font = labelFont
        self.messageLabel.text = "\(text)"
        self.messageLabel.textColor = textColor
        self.messageLabel.textAlignment = (lines > 1) ? .left : .center
    }
    /// 顯示文字框
    /// - Parameters:
    ///   - text: 文字
    ///   - duration: 時間
    ///   - targetFrame: CGRect
    ///   - backgroundViewColor: 背景顏色
    ///   - textColor: 文字顏色
    ///   - height: 與底部的相差高度
    ///   - options: 動畫參數
    func displayText(targetFrame: CGRect, duration: Constant.ToastLength, backgroundViewColor: UIColor, textColor: UIColor, height: CGFloat, options: UIView.AnimationOptions) {
                
        guard !isDisplaing,
              let text = textQueue.first,
              let window = view.window as? WWToastWindow,
              let runningDuration = Optional.some(duration.timeInterval() * 0.5),
              let lines = Optional.some(toastWindowLineCount(targetFrame: targetFrame, text: text, height: height))
        else {
            return
        }
        
        isDisplaing = true
        toastViewControllerSetting(text, lines: lines, duration: duration, backgroundViewColor: backgroundViewColor, textColor: textColor)
        backgroundView.alpha = 0.0
        window.isHidden = false
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: runningDuration, delay: 0, options: options, animations: { [unowned self] in
            backgroundView.alpha = 1.0
            
        }, completion: { _ in
            
            self.delegate?.toastDisplay(window, textQueue: self.textQueue, text: self.textQueue.last, status: .didDisplay)
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: runningDuration, delay: 0, options: options, animations: { [unowned self] in
                
                backgroundView.alpha = 0.0
                delegate?.toastDisplay(window, textQueue: textQueue, text: textQueue.last, status: .willDismiss)
                
            }, completion: { _ in
                window.isHidden = true
                _ = self.textQueue.removeFirst()
                self.isDisplaing = false
                self.delegate?.toastDisplay(window, textQueue: self.textQueue, text: self.textQueue.last, status: .didDismiss)
                self.displayText(targetFrame: targetFrame, duration: duration, backgroundViewColor: backgroundViewColor, textColor: textColor, height: height, options: options)
            })
        })
    }
}
