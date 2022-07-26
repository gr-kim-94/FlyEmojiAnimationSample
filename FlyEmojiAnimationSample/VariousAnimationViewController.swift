//
//  VariousAnimationViewController.swift
//  FlyEmojiAnimationSample
//
//  Created by grkim on 2022/07/26.
//

import UIKit

class VariousAnimationViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Various Animation"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showAnimation))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func showAnimation() {
        (0...8).forEach { _ in
            addAnimationView()
        }
    }
    
    func addAnimationView() {
        
    }
}
