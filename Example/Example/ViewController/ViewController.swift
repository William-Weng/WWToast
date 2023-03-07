//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2023/02/23.
//  ~/Library/Caches/org.swift.swiftpm/
//  file:///Users/william/Desktop/WWToast

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
        
        WWToast.shared.makeText(target: self, text: text, backgroundColor: .red)
    }
}

// MARK: - 小工具
private extension ViewController {
    
    func initSetting() {
        
        showToastLabels.forEach { label in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Self.showToast(_:)))
            label.addGestureRecognizer(tapGesture)
        }
    }
}
