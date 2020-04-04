//
//  WBBaseViewController.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/3.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class WBBaseViewController: UIViewController {
    
    // 自定义导航条
    lazy var navBar = WBNavBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 88))
    // 自定义导航条目
    lazy var navItem = UINavigationItem()
    
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置界面
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupUI() {
        // 设置背景颜色为随机
        view.backgroundColor = UIColor.cz_random()
        navBar.items = [navItem]
        // 设置导航条的背景颜色
        navBar.isTranslucent = false
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        view.addSubview(navBar)
    }
}
