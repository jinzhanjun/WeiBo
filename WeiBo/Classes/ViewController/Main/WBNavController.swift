//
//  WBNavController.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/3.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class WBNavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        navigationBar.isHidden = true
    }
    
    /// 对push方法不满意，需要重写push方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        var backBtn = "返回"
        
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        if children.count == 1 {
            backBtn = children[0].title ?? ""
        }
        
        if let vc = viewController as? WBDemoViewController {
            vc.navItem.leftBarButtonItem = UIBarButtonItem(title: backBtn, target: self, action: #selector(goBack), event: .touchUpInside, imageName: "navigationbar_back_withtext", highlightedName: "navigationbar_back_withtext_highlighted")
            vc.title = "第 \(children.count) 页"
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func goBack() {
        popViewController(animated: true)
    }
}
