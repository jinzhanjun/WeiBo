//
//  WBUserAccount.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/16.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation

class WBUserAccount: NSObject {
    // 访问令牌
    @objc var access_token: String?
    // 有效时长
    @objc var expires_in: String?
    // 是否真名
//    @objc var isRealName: Bool?
    // 有效时长
    @objc var remind_in: Int = 0 {
        didSet {
            
            expiresDate = Date(timeIntervalSinceNow: Double(remind_in))
        }
    }
    // App标识
    @objc var uid: Int = 0
    
    // 过期日期
    @objc var expiresDate: Date?
    
    
    // - 用户信息
    // 头像
    @objc var avatar_large: String?
    
    @objc var name: String?
    
    override var description: String {
        return yy_modelDescription()
    }
    
    override init() {
        super.init()
        
        // 获取沙盒路径
        let path = UserAccountFile.appendDocumentPath
        
        // 获取数据
        guard let url = URL(string: path),
            let data = try? Data(contentsOf: url),
            let json: [String: Any] = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            else { return }
        
        // 字典转模型
        self.yy_modelSet(withJSON: json)
    }
    
    /// 保存模型至沙盒
    func save() {
        /*
         保存方式：
         1、plist
         2、沙盒 归档/json/
         3、CoreData
         4、钥匙串
        **/
        // 本次采用json的形式
        // 获取沙盒路径字符串
        let path = UserAccountFile.appendDocumentPath
        print(path)
        
        // 模型转字典
        var dict = self.yy_modelToJSONObject() as? [String: Any] ?? [:]
        
        // 移除无用信息
        dict.removeValue(forKey: "expires_in")
        // 字典序列化
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let url = URL(string: path)
            else { return }
        try? data.write(to: url)
    }
}
