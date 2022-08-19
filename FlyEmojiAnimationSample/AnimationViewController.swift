//
//  AnimationViewController.swift
//  FlyEmojiAnimationSample
//
//  Created by grkim on 2022/07/22.
//

import UIKit

class AnimationViewController: UIViewController {
    var stackView: UIStackView = UIStackView()
    
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
        
        self.view.addSubview(self.stackView)
        self.stackView.axis = .horizontal
        self.stackView.distribution = .fillEqually
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.stackView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.defaultSetting()
    }
    
    private func defaultSetting() {
        let noneButton = UIButton()
        noneButton.setTitleColor(.black, for: .normal)
        noneButton.setTitle("none", for: .normal)
        noneButton.addAction(UIAction(handler: { action in
            self.showAnimation(.none)
        }), for: .touchUpInside)
        self.stackView.addArrangedSubview(noneButton)
        
        let randomButton = UIButton()
        randomButton.setTitleColor(.black, for: .normal)
        randomButton.setTitle("random", for: .normal)
        randomButton.addAction(UIAction(handler: { action in
            self.showAnimation(.random)
        }), for: .touchUpInside)
        self.stackView.addArrangedSubview(randomButton)
        
        let awayButton = UIButton()
        awayButton.setTitleColor(.black, for: .normal)
        awayButton.setTitle("away", for: .normal)
        awayButton.addAction(UIAction(handler: { action in
            self.showAnimation(.away)
        }), for: .touchUpInside)
        self.stackView.addArrangedSubview(awayButton)
        
        let scaleButton1 = UIButton()
        scaleButton1.setTitleColor(.black, for: .normal)
        scaleButton1.setTitle("scale1", for: .normal)
        scaleButton1.addAction(UIAction(handler: { action in
            self.showAnimation(.scale1)
        }), for: .touchUpInside)
        self.stackView.addArrangedSubview(scaleButton1)
        
        // test
        let scaleButton2 = UIButton()
        scaleButton2.setTitleColor(.black, for: .normal)
        scaleButton2.setTitle("scale2", for: .normal)
        scaleButton2.addAction(UIAction(handler: { action in
            self.showAnimation(.scale2)
        }), for: .touchUpInside)
        self.stackView.addArrangedSubview(scaleButton2)
    }
    
    // MARK: - Animation
    private let delayMin: CGFloat = 0.1
    private let delayMax: CGFloat = 1.0
    
    func showAnimation(_ style: FlyStyle) {
        (0...8).forEach { _ in
            // 등장 시간 : 0.1 ~ 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + CGFloat.random(in: delayMin...delayMax)) {
                // Add Reaction Item View
                let imageView = FlyImageView(name: "hello")
                imageView.style = style
                self.view.addSubview(imageView)
                
                imageView.animateInView(view: self.view) { finished in
                    // End Reaction Animation
                }
            }
        }
    }
}
