//
//  SceneDelegate.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/3.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow()
        window?.windowScene = windowScene
        window?.frame = UIScreen.main.bounds
        window?.backgroundColor = .white
        
        window?.rootViewController = WBMainViewController()
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(resetRootViewController), name: .WBUserHasLogin, object: nil)
        
        
        // 从网络获取APP数据
        getAppInfo()
        // 设置APP的用户授权
        setupAppSettings()
        window?.makeKeyAndVisible()
    }
}

/// 用户授权
extension SceneDelegate {
    private func setupAppSettings() {
        // 获取用户授权，发送通知、消息、声音等
        // available 判断用户系统是否是10.0及以上。
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .carPlay]) { (isAuthorized, error) in
                print(isAuthorized)
            }
        }else {
            let notification = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            UIApplication.shared.registerUserNotificationSettings(notification)
        }
    }
}

/// 模拟从网络获取App配置信息
extension SceneDelegate {
    private func getAppInfo() {
        DispatchQueue.global().async {
            
            // 获取路径
            let url = URL(fileURLWithPath: "Users/jinzhanjun/Desktop/mian.json")
            // 获取二进制数据
            let data = try? Data(contentsOf: url)
            
            // 获取沙盒路径
            var sandBoxUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            sandBoxUrl?.appendPathComponent("main.json")
            // 将数据写入url
            
            try? data?.write(to: sandBoxUrl!)
        }
    }
}

/// 登录后跳转界面
extension SceneDelegate {
    
    @objc func resetRootViewController() {
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            if sceneDelegate.window?.rootViewController != nil {
                sceneDelegate.window?.rootViewController = nil
            }
            
            sceneDelegate.window?.rootViewController = WBMainViewController()
        }
    }
}
