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
        // 从网络获取APP数据
        getAppInfo()
        window?.makeKeyAndVisible()
    }
}

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

