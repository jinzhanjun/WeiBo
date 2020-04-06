//
//  WBMainViewController.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/3.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit
import Foundation
class WBMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 添加撰写按钮
        addComposeBtn()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    //MARK: - 设置界面
    private func setupUI() {
        // 添加子控制器
        addChildControllers()
    }
    
    
    /// 添加子控制器
    private func addChildControllers() {
        classDic.forEach{ addChild(childController(with: $0)) }
    }
    
    @objc private func compose() {
        print("撰写微博")
    }
}

extension WBMainViewController {
    
    private func addComposeBtn() {
        let width = tabBar.bounds.width / CGFloat(children.count) - 1
        
        let composeBtn: UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
        composeBtn.frame = tabBar.bounds.insetBy(dx: 2 * width, dy: 0)
        
        tabBar.addSubview(composeBtn)
        
        composeBtn.addTarget(self, action: #selector(compose), for: .touchUpInside)
    }
    
    
    var classDic: [[String: Any]] {
        return [
            ["clsName": "WBHomeViewController", "title": "首页", "imageName": "home", "visitoViewInfo": ["imageName": "", "message": "关注一些人，能够看到他们的往事！"]],
            ["clsName": "WBDiscoverViewController", "title": "发现", "imageName": "discover", "visitoViewInfo": ["imageName": "visitordiscover_image_message", "message": "关注一些人，能够看到他们的往事！"]],
            ["clsName": "ViewController"],
            ["clsName": "WBMessageViewController", "title": "消息", "imageName": "message_center", "visitoViewInfo": ["imageName": "visitordiscover_image_message", "message": "关注一些人，能够看到他们的往事！"]],
            ["clsName": "WBProfileViewController", "title": "我", "imageName": "profile", "visitoViewInfo": ["imageName": "visitordiscover_image_profile", "message": "关注一些人，能够看到他们的往事！"]]
        ]
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
