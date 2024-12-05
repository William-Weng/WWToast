//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2024/12/4.
//

import UIKit
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
        
        WWToast.shared.makeText(text)
    }
}

// MARK: - 小工具
private extension ViewController {
    
    func initSetting() {
                
        WWToast.shared.setting(backgroundViewColor: .systemPink)
        
        showToastLabels.forEach { label in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Self.showToast(_:)))
            label.addGestureRecognizer(tapGesture)
        }
    }
}

