//
//  WBMainViewController.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/3.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class WBMainViewController: UITabBarController {
    
    // 登录界面
    lazy var loginViewController = WBLoginViewController()
    
    // 时钟
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //FIXME:  设置时钟 (只有当登录以后才设置时钟)
        WBNetWorkingController.shared.userAccount.access_token != nil ? setupTimer() : ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 添加撰写按钮
        addComposeBtn()
        
        print("MainViewController 即将显示")
    }
    
    deinit {
        // 销毁时钟
        timer?.invalidate()
        
        // 注销用户登录通知
        NotificationCenter.default.removeObserver(self, name: .WBUserShouldLogon, object: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    //MARK: - 设置界面
    private func setupUI() {
        // 添加子控制器
        addChildControllers()
        delegate = self
        
        // 设置新特性页面
        setNewVersionView()
        
        // 注册用户登录通知
        NotificationCenter.default.addObserver(self, selector: #selector(showLoginView), name: .WBUserShouldLogon, object: nil)
    }
    
    /// 展示登录界面的方法，一般需要用nav包一下
    @objc private func showLoginView() {
        
        let nav = UINavigationController(rootViewController: loginViewController)
        
        present(nav, animated: true, completion: nil)
    }
    
    
    /// 添加子控制器
    private func addChildControllers() {
        classDic.forEach{ addChild(childController(with: $0)) }
    }
    
    @objc private func compose() {
        print("撰写微博")
    }
    
    /// 设置时钟
    private func setupTimer() {
        // 设置时钟， timer对target强引用
        timer = Timer.scheduledTimer(timeInterval: 360, target: self, selector: #selector(setUnreadCount), userInfo: nil, repeats: true)
    }
    
    /// 设置首页的badgeNumber显示未读微博数量
    @objc private func setUnreadCount() {
        
        print("时钟加载")
        WBNetWorkingController.shared.requestUnreadCount { (unReadCount) in
            
            print("刷新到 \(unReadCount) 条微博")
            // 设置首页标签的badgenumber
            self.children[0].tabBarItem.badgeValue = unReadCount > 0 ? "\(unReadCount)" : nil
            
            // 设置App图标的badgeNumber
            UIApplication.shared.applicationIconBadgeNumber = unReadCount
        }
    }
}

/// 设置是否显示新特性页面
extension WBMainViewController {
    /// 检查新特性
    private func setNewVersionView() {
        
        // 检查是否为新版本
        let v = WBWelcomeView.wbWelcomeView()
        
        view.addSubview(v)
    }
    
    // 是否为新版本
    private var isNewVersion: Bool {
        let defaults = UserDefaults.standard
        // 获取当前版本信息
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return false }
        
        // 获取旧版本信息
        let oldVersion = defaults.value(forKey: "VersionString") as? String
        
        
        if currentVersion != oldVersion {
            print("新版本!!")
            // 设置APP新版本
            defaults.setValue(currentVersion, forKey: "VersionString")
            
            return true
        } else {
            return false
        }
    }
}

/// delegate
extension WBMainViewController: UITabBarControllerDelegate {
    /// 是否激活 即将点击的控制器
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 解决撰写微博按钮穿帮的问题
        // 如果双击首页tabBar，就重新刷新数据，数据列表返回顶层
        // 1. 获取当前控制器的index
        let currentIndex = (children as NSArray).index(of: viewController)
        
        if selectedIndex == 0 && selectedIndex == currentIndex,
            let homeNav = children[0] as? WBNavController,
            let homeVC = homeNav.children[0] as? WBHomeViewController
        {
            
            homeVC.tableView?.setContentOffset(CGPoint(x: 0, y: -homeVC.navBar.bounds.height), animated: true)
            
            homeVC.loadData()
        }
        
//
//        if viewController == tabBarController.selectedViewController {
//            if let homeVC = viewController.children[0] as? WBHomeViewController {
//
//                homeVC.tableView?.setContentOffset(CGPoint(x: 0, y: -homeVC.navBar.bounds.height), animated: true)
//
//                homeVC.loadData()
//            }
//        }
        return !viewController.isMember(of: UIViewController.self)
    }
}

/// 设置子控制器
extension WBMainViewController {
    
    private func addComposeBtn() {
        let width = tabBar.bounds.width / CGFloat(children.count)
        
        let composeBtn: UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
        composeBtn.frame = tabBar.bounds.insetBy(dx: 2 * width, dy: 0)
        
        tabBar.addSubview(composeBtn)
        
        composeBtn.addTarget(self, action: #selector(compose), for: .touchUpInside)
    }
    
    
    var classDic: [[String: Any]] {
        // 从沙盒中加载
        // 1> 获取沙盒路径
        guard var sandBoxUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return [] }
        sandBoxUrl.appendPathComponent("main.json")
        // 2> 获取data
        var data = try? Data(contentsOf: sandBoxUrl)
        
        // 如果从没有从网络获取到数据
        if data == nil {
            // 直接从Bundle中加载
            let path = Bundle.main.path(forResource: "mian.json", ofType: nil)
            data = try! NSData(contentsOfFile: path!) as Data
        }

        // 3> 反序列化，转为APP信息字典
        let array = try? JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]]
        return array!
    }
    
    
    private func childController(with dic: [String: Any]) -> UIViewController {
        
        guard let clsNameString = dic["clsName"] as? String,
            let title = dic["title"] as? String,
            let imageName = dic["imageName"] as? String,
            let visitorInfoDic = dic["visitoViewInfo"] as? [String: String] ,
            let clsName = NSClassFromString(Bundle.nameSpace + clsNameString) as? WBBaseViewController.Type
            else { return UIViewController()}

        let cls = clsName.init()
        
        // 设置访客视图信息字典
        cls.visitorInfoDic = visitorInfoDic
        
        cls.title = title
        cls.tabBarItem = UITabBarItem(title: title, image: UIImage(named: "tabbar_" + imageName), selectedImage: UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal))
        var font: UIFont {
            return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body)).withSize(12)
        }
        // 设置tabBar标题字体大小
        cls.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        // 设置tabBar标题颜色
        cls.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], for: .selected)
        let vc = WBNavController(rootViewController: cls)
        return vc
    }
}
