//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2024/12/4.
//

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

