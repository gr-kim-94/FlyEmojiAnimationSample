//
//  AnimationViewController.swift
//  FlyEmojiAnimationSample
//
//  Created by grkim on 2022/07/22.
//

import UIKit

class AnimationViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Animation"
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
        let imageView = UIImageView(image: UIImage(named: "hello"))
        imageView.contentMode = .scaleAspectFit
        imageView.animationRepeatCount = 1
        imageView.animationDuration = 3
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let randomSize = 30 + drand48() * 10
        imageView.frame = CGRect(x: 0, y: 0, width: randomSize, height: randomSize)
        imageView.alpha = drand48()
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = upCurvedPath(imageView: imageView).cgPath
        animation.duration = 2 + drand48() * 3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        imageView.layer.add(animation, forKey: nil)
        
        self.view.addSubview(imageView)
    }
    
    func upCurvedPath(imageView: UIImageView) -> UIBezierPath {
        let path = UIBezierPath()
        
        let randomX: CGFloat = CGFloat(arc4random_uniform(UInt32(self.view.frame.size.width)))
        
        let startPoint = CGPoint(x: randomX, y: self.view.frame.size.height)
        let endPoint = CGPoint(x: randomX, y: -imageView.frame.size.height)
        
        path.move(to: startPoint)
        
        let randomXShift = randomX + drand48() * 300
        let cp1 = CGPoint(x: randomX - randomXShift, y: self.view.frame.size.height / 3)
        let cp2 = CGPoint(x: randomX + randomXShift, y: (self.view.frame.size.height * 2) / 3)
        path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        
        return path
    }
}
