//
//  LottieViewController.swift
//  FlyEmojiAnimationSample
//
//  Created by grkim on 2022/07/22.
//

import UIKit
import Lottie

private let lottieCount: Int = 8

class LottieViewController: UIViewController {
    var currentCount: Int = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Lottie"
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
        self.view.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        self.currentCount = 0
        
        (0...lottieCount).forEach { _ in
            addAnimationView()
        }
    }
    
    func addAnimationView() {
        let animationView = AnimationView(animation: Animation.named("lottie_hello")!)
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 3
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        let randomX: CGFloat = CGFloat(arc4random_uniform(UInt32(self.view.frame.size.width)))
        
        // width를 줄이면 lottie 내부 비율에 맞춰서 height도 줄어듬
        let width = self.view.frame.size.width/3
        animationView.frame = CGRect(x: randomX, y: 0, width: width, height: self.view.frame.size.height)
        
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce)
        
        self.view.addSubview(animationView)
        self.currentCount += 1
    }
}
