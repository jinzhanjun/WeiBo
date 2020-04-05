//
//  WBBaseViewController.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/3.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

private let cellID = "cellID"

class WBBaseViewController: UIViewController {
    
    // 自定义导航条
    lazy var navBar = WBNavBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 88))
    // 自定义导航条目
    lazy var navItem = UINavigationItem()
    
    // 表格
    var tableView: UITableView?
    // 刷新控制器
    var refreshController: UIRefreshControl?
    
    // 标题
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
    
    /// 设置界面
    func setupUI() {
        
        // 禁止自动缩进
//        automaticallyAdjustsScrollViewInsets = false
        // 设置导航栏
        setupNavBar()
        // 设置表格
        setupTabelView()
        
        // 加载数据
        loadData()
    }
    
    /// 加载数据
    @objc func loadData() {
        
    }
    
    /// 导航栏
    private func setupNavBar() {
        navBar.items = [navItem]
        // 设置导航条的背景颜色
        navBar.isTranslucent = false
        navBar.tintColor = UIColor.orange
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        view.addSubview(navBar)
    }
    
    /// 表格
    private func setupTabelView() {
        tableView = UITableView(frame: view.bounds)
        // 禁止自动缩进
        tableView?.contentInsetAdjustmentBehavior = .never
        
        // 设置内容缩进
        tableView?.contentInset = UIEdgeInsets(
            top: navBar.bounds.height,
            left: 0,
            bottom: tabBarController?.tabBar.bounds.height ?? 0,
            right: 0)
        
        // 设置代理
        tableView?.delegate = self
        // 设置数据源
        tableView?.dataSource = self
        
        view.insertSubview(tableView!, belowSubview: navBar)
        
        // 注册cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        // 设置刷新
        refreshController = UIRefreshControl()
        // 添加监听方法
        refreshController?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView?.addSubview(refreshController!)
        
    }
}

//MARK: - tableDelegate & tableDataSource （添加数据源方法，具体由子类实现）
extension WBBaseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
