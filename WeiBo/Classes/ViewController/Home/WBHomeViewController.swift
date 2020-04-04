//
//  WBHomeViewController.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/3.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class WBHomeViewController: WBBaseViewController {
    
    override func setupUI() {
        super.setupUI()
        navItem.leftBarButtonItem = UIBarButtonItem(title: "添加好友", target: self, action: #selector(addFridens), event: .touchUpInside)
    }
    
    /// 添加好友
    @objc private func addFridens() {
        
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
