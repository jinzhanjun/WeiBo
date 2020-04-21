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
    
    // 配置访客视图信息字典
    var visitorInfoDic: [String: String]?
    
    // 自定义导航条
    lazy var navBar = WBNavBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 88))
    // 自定义导航条目
    lazy var navItem = UINavigationItem()
    
//    // 标记是否登录
//    var userLogon = false
    
    // 是否上拉刷新
    var isPullUp = false
    
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
        
        // 注册用户已经登录的通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userLogin),
            name: .WBUserHasLogin,
            object: nil)
        print("视图已经加载")
    }
    
    // 注销
    deinit {
        NotificationCenter.default.removeObserver(self, name: .WBUserHasLogin, object: nil)
    }
    
    //用户登录后
    @objc private func userLogin(n: Notification) {
//
        // 新版本无法使用了
//        view = nil
//        
//        navItem.rightBarButtonItem = nil
//        navItem.backBarButtonItem = nil
//        NotificationCenter.default.removeObserver(self, name: .WBUserHasLogin, object: nil)
    }
    
    /// 设置界面
    private func setupUI() {
        // 设置导航栏
        setupNavBar()
        
        // 根据是否登录，来确定加载哪一个界面
        WBNetWorkingController.shared.shouldLogon ? setupTabelView() : setupVisitorView()
    }
    
    /// 加载数据
    @objc func loadData() {
        
        // 如果子类不实现任何数据方法，就结束刷新
        refreshController?.endRefreshing()
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
    
    /// 登录界面
    func setupVisitorView() {
        let visitorView = WBVisitorView(frame: view.bounds)
        
        // 根据字典配置内容
        visitorView.infoDic = visitorInfoDic
        
        // 设置背景颜色
        visitorView.backgroundColor = UIColor.cz_color(withHex: 0xEDEDED)
        
        // 导航条登录注册按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", target: self, action: #selector(regist), event: .touchUpInside)
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", target: self, action: #selector(login), event: .touchUpInside)
        
        // 将访客视图中的每一个子视图都取消 ”translatesAutoresizingMaskIntoConstraints“
        // 系统默认赋予控件autoresizing约束
        visitorView.subviews.forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }
        
        // 登录注册监听方法
        visitorView.registBtn.addTarget(self, action: #selector(regist), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        // 插入视图至导航条下面
        view.insertSubview(visitorView, belowSubview: navBar)
    }
    
    /// 表格
    func setupTabelView() {
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
        
        // 设置滚动条下移，防止navBar的遮挡
        tableView?.scrollIndicatorInsets = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        
        view.insertSubview(tableView!, belowSubview: navBar)
        
        // 注册cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        // 设置刷新
        refreshController = UIRefreshControl()
        // 添加监听方法
        refreshController?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView?.addSubview(refreshController!)
        // 加载数据
        loadData()
        
    }
}
//MARK: - 注册登录监听方法
extension WBBaseViewController {
    @objc private func regist() {
        print("点击注册")
    }
    
    //FIXME: 不应该放在这里，因为base没有实例，登录应属于顶层控制器
    @objc private func login() {
        print("点击登录")
        
        // 发送需要用户登录的通知
        NotificationCenter.default.post(name: .WBUserShouldLogon, object: nil)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if tableView.numberOfSections < 0 {
            return
        }
        
        // 判断显示的cell是否为最后一个section和 最大的row
        let section = tableView.numberOfSections - 1
        let row = tableView.numberOfRows(inSection: section) - 1
        
        // 如果即将显示最后一组的最后一个row
        if indexPath.section == section && indexPath.row == row {
            
            // 上拉刷新标记
            isPullUp = true
            
            // 加载数据
            loadData()
        }
    }
}
