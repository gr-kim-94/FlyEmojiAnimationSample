//
//  MainViewController.swift
//  FlyEmojiAnimationSample
//
//  Created by grkim on 2022/07/22.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = .white
        tabBar.tintColor = .white
        tabBar.barTintColor = .red
        tabBar.shadowImage = UIImage()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .red
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        viewControllers = [
            UINavigationController(rootViewController:  LottieViewController()),
            UINavigationController(rootViewController:  AnimationViewController())
        ]
    }


}

