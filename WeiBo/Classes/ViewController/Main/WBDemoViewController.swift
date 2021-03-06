//
//  WBDemoViewController.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/4.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class WBDemoViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupTabelView() {
        super.setupTabelView()
        navItem.rightBarButtonItem = UIBarButtonItem(title: "下一页", target: self, action: #selector(showNext), event: .touchUpInside)
    }
    
    @objc private func showNext() {
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
