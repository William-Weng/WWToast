# WWToast

[![Swift-5.6](https://img.shields.io/badge/Swift-5.6-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-14.0](https://img.shields.io/badge/iOS-14.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![](https://img.shields.io/github/v/tag/William-Weng/WWToast) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

## [Introduction - 簡介](https://swiftpackageindex.com/William-Weng)
- A small tool imitating Android's [Toast](https://developer.android.com/guide/topics/ui/notifiers/toasts) function...
- 一個仿Android的[Toast](https://developer.android.com/guide/topics/ui/notifiers/toasts?hl=zh-tw)功能的小工具…

![](./Example.gif)

## [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)

```bash
dependencies: [
    .package(url: "https://github.com/William-Weng/WWToast.git", .upToNextMajor(from: "1.2.2"))
]
```

### [Function - 可用函式](https://www.ithome.com.tw/articles/10293984)
|函式|功能|
|-|-|
|makeText(target:text:duration:backgroundColor:textColor:height:)|[顯示文字](https://kotlin.litotom.com/android-zhuan-an-kai-fa/6-activity-she-ji/6.4-shi-yong-fu-dong-xian-shi-toast-lei-bie)|

## Example
```swift
import UIKit
import WWPrint
import WWToast

final class ViewController: UIViewController {
    
    @IBOutlet var showToastLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    @objc func showToast(_ recognizer: UITapGestureRecognizer) {
        
        guard let label = recognizer.view as? UILabel,
              let text = label.text
        else {
            return
        }
        
        WWToast.shared.makeText(target: self, text: text, backgroundColor: UIColor._random(), textColor: UIColor._random())
    }
}

// MARK: - WWToastDelegate
extension ViewController: WWToastDelegate {
    
    func willDisplay(window: WWToastWindow?, textList: [String], text: String?) {
        wwPrint("textList =? \(textList), text => \(text ?? "nil")")
    }
    
    func didDisplay(window: WWToastWindow?, textList: [String], text: String?) {
        wwPrint("textList =? \(textList), text => \(text ?? "nil")")
    }
    
    func willDismiss(window: WWToastWindow?, textList: [String], text: String?) {
        wwPrint("textList =? \(textList), text => \(text ?? "nil")")
    }

    func didDismiss(window: WWToastWindow?, textList: [String], text: String?) {
        wwPrint("textList =? \(textList), text => \(text ?? "nil")")
    }
}

// MARK: - 小工具
private extension ViewController {
    
    func initSetting() {
        
        WWToast.shared.delegate = self
        
        showToastLabels.forEach { label in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Self.showToast(_:)))
            label.addGestureRecognizer(tapGesture)
        }
    }
}
```
