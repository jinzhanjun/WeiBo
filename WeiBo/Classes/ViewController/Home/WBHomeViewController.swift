//
//  WBHomeViewController.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/3.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class WBHomeViewController: WBBaseViewController {
    
    // 数据列表
    private lazy var statusList = [String]()
    
    
    override func setupUI() {
        super.setupUI()
        navItem.leftBarButtonItem = UIBarButtonItem(title: "添加好友", target: self, action: #selector(addFridens), event: .touchUpInside)
    }
    
    // 重写加载数据方法
    override func loadData() {
        for i in 0..<25 {
            statusList.insert(i.description, at: 0)
        }
    }

    /// 添加好友
    @objc private func addFridens() {
        
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        cell.textLabel?.text = statusList[indexPath.row]
        
        return cell
    }
}
