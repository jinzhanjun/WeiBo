//
//  WBCommon.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/15.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation

// 用户信息数据
var UserAccountFile = "WBUserAccount.json"

// 应用识别代码
let Uid: String = "1702281849"

// 应用APPSecret
let WBSecret = "6bea576eb06abcbd81e63376e0e1e60d"

// 回调地址
let WBRedirect_URI: String = "http://baidu.com"

// 授权页面
let OauthUrl: String = "https://api.weibo.com/oauth2/authorize"

/// 增加通知的名字的属性
extension NSNotification.Name {
    static var WBUserShouldLogon: NSNotification.Name {
        return NSNotification.Name("WBUserShouldLogon")
    }
    
    static var WBUserHasLogin: NSNotification.Name {
        return NSNotification.Name("WBUserHasLogin")
    }
}

extension String {
    var appendDocumentPath: String {
        // 获取沙盒路径
        guard let sandPathStr = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil
            , create: true).absoluteString else {
                return ""
        }
        
        let filePathStr = sandPathStr + "\(self)"
        
        return filePathStr
    }
}
