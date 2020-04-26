//
//  WBHomeViewController.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/3.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class WBHomeViewController: WBBaseViewController {
    
    // 视图模型
    private lazy var statusViewModelArray = WBStatusListViewModel()
    
    override func setupTabelView() {
        super.setupTabelView()
        navItem.leftBarButtonItem = UIBarButtonItem(title: "添加好友", target: self, action: #selector(addFridens), event: .touchUpInside)
        
        let button = WBNavButton(title: WBNetWorkingController.shared.userAccount.name)
        
        navItem.titleView = button
        
        // 注册原型Cell
        tableView?.register(UINib(nibName: "WBStatusCell", bundle: nil), forCellReuseIdentifier: "WBStatusCell")
        
        tableView?.cellLayoutMarginsFollowReadableWidth = true
        
        // 设置预估行高
        tableView?.estimatedRowHeight = 300
        
        // 取消分割线
        tableView?.separatorStyle = .none
    }
    
    // 重写加载数据方法
    override func loadData() {
        
        statusViewModelArray.setupModel(pullUp: isPullUp) { (isComplete, shouldRefresh) in
            if isComplete {
//                self.statusList = self.statusViewModel.statusModelArray
                // 恢复上拉标记
                self.isPullUp = false
                // 停止刷新控件
                self.refreshController?.endRefreshing()
                // 表格视图重新加载数据
                if shouldRefresh {
                    self.tableView?.reloadData()
                }
            }
        }
    }

    /// 添加好友
    @objc private func addFridens() {
        
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        statusList.count
        statusViewModelArray.statusModelArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WBStatusCell", for: indexPath) as! WBStatusView
        
        let viewModel = statusViewModelArray.statusModelArray[indexPath.row]
        
        cell.viewModel = viewModel
        return cell
    }
}
