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
        addChildControllers()
    }
    
    private func addChildControllers() {
        classDic.forEach{ addChild(childController(with: $0)) }
        
    }
}

extension WBMainViewController {
    
    var classDic: [[String: String]] {
        return [
            ["clsName": "WBHomeViewController", "title": "首页", "imageName": "home"],
            ["clsName": "WBDiscoverViewController", "title": "发现", "imageName": "discover"],
            ["clsName": "ViewController"],
            ["clsName": "WBMessageViewController", "title": "消息", "imageName": "message_center"],
            ["clsName": "WBProfileViewController", "title": "我", "imageName": "profile"]
        ]
    }
    
    
    private func childController(with dic: [String: String]) -> UIViewController {
        
        guard let clsNameString = dic["clsName"],
            let title = dic["title"],
            let imageName = dic["imageName"],
            let clsName = NSClassFromString(Bundle.nameSpace + clsNameString) as? WBBaseViewController.Type
            else { return UIViewController()}

        let cls = clsName.init()
        
        cls.title = title
        cls.tabBarItem = UITabBarItem(title: title, image: UIImage(named: "tabbar_" + imageName), selectedImage: UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal))
        let vc = WBNavController(rootViewController: cls)
        return vc
    }
}
