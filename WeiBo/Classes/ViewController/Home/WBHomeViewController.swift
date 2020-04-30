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
        // 微博
        tableView?.register(UINib(nibName: "WBStatusCell", bundle: nil), forCellReuseIdentifier: "WBStatusCell")
        // 转发微博
        tableView?.register(UINib(nibName: "WBRetweetedStatusCell", bundle: nil), forCellReuseIdentifier: "WBRetweetedStatusCell")
        
        
        tableView?.cellLayoutMarginsFollowReadableWidth = true
        
        // 设置预估行高
        tableView?.estimatedRowHeight = 0
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return statusViewModelArray.statusModelArray[indexPath.row].cellHeight ?? CGFloat(0)
        
//        return CGFloat(400)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellID = "WBStatusCell"
        
        let viewModel = statusViewModelArray.statusModelArray[indexPath.row]
        
        if viewModel.statusModel.retweeted_status != nil {
            cellID = "WBRetweetedStatusCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WBStatusView
        
        cell.viewModel = viewModel
        return cell
    }
}
