//
//  FlyImageView.swift
//  FlyEmojiAnimationSample
//
//  Created by grkim on 2022/08/16.
//

import UIKit

enum RotationDirection: CGFloat {
    case Left = -1
    case Right = 1
    
    static func randomDirection() -> RotationDirection {
        return Bool.random() ? Left : Right
    }
}

enum FlyStyle {
    case none
    case random // alpha 랜덤값
    case away   // alpha 0.9에서 시작해서 0으로 사라지는 스타일
    case scale1  // scale 줄어들면서 사라지는 스타일
    case scale2  // 일정 시간 후 scale 줄어들면서 사라지는 스타일
}

private let kMinSize: Int = 32
private let kMaxSize: Int = 40

private let kMinAlpha: CGFloat = 0.3
private let kMinScale: CGFloat = 0.3

public class FlyImageView: UIView {
    var name: String?
    var style: FlyStyle = .none
    
    private var animateCompletion: ((Bool) -> Void)?
    
    private struct Durations {
        static let Bloom: TimeInterval = 0.3 // Start
        static let Full: TimeInterval = 2
    }
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
    }
    
    public init(name: String) {
        // 랜덤 사이즈
        let randomSize = Int.random(in: kMinSize...kMaxSize)
        let frame = CGRect(x: 0, y: 0, width: randomSize, height: randomSize)
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        self.name = name
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Math Helpers
    private func randomNumber(cap: Int) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(cap)))
    }
    
    private func randomNumber(cap: CGFloat) -> CGFloat {
        return randomNumber(cap: Int(cap))
    }
    
    private func randomFloat(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random(in: min...max)
    }
    
    // MARK: - Animations
    public func animateInView(view: UIView, completion: ((Bool) -> Void)? = nil) {
        self.animateCompletion = completion
        
        prepareForAnimation()
        performBloomAnimation()
        performSlightRotationAnimation(direction: RotationDirection.randomDirection())
        addPathAnimation(inView: view)
    }
    
    private func prepareForAnimation() {
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.alpha = 0.0
    }
    
    private func performBloomAnimation() {
        // start animation
        UIView.animate(withDuration: Durations.Bloom, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: []) {
            self.transform = .identity
            var startAlpha = 1.0
            if self.style == .away {
                startAlpha = 0.9
            } else if self.style == .random {
                startAlpha = self.randomFloat(min: 0.5, max: 1.0)
            }
            self.alpha = startAlpha
        } completion: { finished in
        }
    }
    
    private func performSlightRotationAnimation(direction: RotationDirection) {
        let rotationFraction = randomNumber(cap: 10)
        UIView.animate(withDuration: Durations.Full, animations: {
            self.transform = CGAffineTransform(rotationAngle: direction.rawValue * .pi / (16 + rotationFraction * 0.2))
        }, completion: { finished in
        })
    }
    
    private func animateToFinalAlpha(withDuration duration: TimeInterval = Durations.Full) {
        if self.style == .away {
            UIView.animate(withDuration: duration, animations: {
                self.alpha = 0.0
            }, completion: { finished in
                self.removeFromSuperview()
                
                self.animateCompletion?(finished)
            })
        } else if self.style == .scale1 {
            UIView.animate(withDuration: duration - 0.1, delay: 0, options: .curveLinear) {
                self.transform = CGAffineTransform(scaleX: kMinScale, y: kMinScale)
            } completion: { finished in
                self.removeFromSuperview()
                
                self.animateCompletion?(finished)
            }
        } else if self.style == .scale2 {
            let endDuration = duration - 0.1
            // 아이콘 사라지는 시간
            let scaleDuration = CGFloat.random(in: 0.3...0.5)
            UIView.animate(withDuration: scaleDuration, delay: endDuration - scaleDuration, options: .curveLinear) {
                self.transform = CGAffineTransform(scaleX: kMinScale, y: kMinScale)
            } completion: { finished in
                self.removeFromSuperview()
                
                self.animateCompletion?(finished)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration - self.randomFloat(min: 0.5, max: 1.0)) {
                self.removeFromSuperview()
                
                self.animateCompletion?(true)
            }
        }
    }
    
    // MARK: - Path
    private func travelPath(inView view: UIView) -> UIBezierPath? {
        let leftX: CGFloat = 10  // 양쪽 여백 10
        let size = bounds.width
        let viewWidth = view.bounds.width - (leftX * 2)
        let viewHeight = view.bounds.height
        
        //random end point
        let startPointX = leftX + randomNumber(cap: viewWidth)
        let startPointY = viewHeight
        let startPoint = CGPoint(x: startPointX, y: startPointY)
        
        //random end point
        let endPointX = startPointX
        let endPointY = 0.0 + randomNumber(cap: viewHeight / 3)
        let endPoint = CGPoint(x: endPointX, y: endPointY)
        
        //random Control Points
        let deltaX = (size + randomNumber(cap: 2 * size)) * RotationDirection.randomDirection().rawValue
        let curvedRangeY = (startPointY - endPointY) / 5
        let deltaY = max(endPoint.y, curvedRangeY + randomNumber(cap: curvedRangeY * 2))
        let controlPoint1 = CGPoint(x: startPointX + deltaX, y: viewHeight - deltaY)
        let controlPoint2 = CGPoint(x: startPointX - deltaX, y: deltaY)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
        return path
    }
    
    private func addPathAnimation(inView view: UIView) {
        guard let travelPath = travelPath(inView: view) else { return }
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "position")
        keyFrameAnimation.path = travelPath.cgPath
        keyFrameAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        let durationAdjustment = Durations.Full * TimeInterval(travelPath.bounds.height / view.bounds.height)
        let duration = Durations.Full + durationAdjustment
        keyFrameAnimation.duration = duration
        layer.add(keyFrameAnimation, forKey: "positionOnPath")
        
        animateToFinalAlpha(withDuration: duration)
    }
    
    // MARK: - Draw
    override public func draw(_ rect: CGRect) {
        guard let imageName = self.name else {
            super.draw(rect)
            return
        }
        
        let imageBundle = Bundle(for: FlyImageView.self)
        let image = UIImage(named: imageName, in: imageBundle, compatibleWith: nil)
        image?.draw(in: rect, blendMode: .normal, alpha: 1.0)
    }
}
