//
//  WBNetWorkingController.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/7.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit
import AFNetworking

enum RequestMethod {
    case GET
    case POST
}

class WBNetWorkingController: AFHTTPSessionManager {

    // 创建单例，存储在静态区（常量区），无论哪个控制器访问，都是同一个地址
    static let shared = WBNetWorkingController()
    
    // 微博数据模型
    lazy var userAccount = WBUserAccount()
    
    // 用户登录标识
    var shouldLogon: Bool {
        return userAccount.access_token != nil
    }

    // 封装一个专门做新浪微博请求的方法
    func tokenRequest(requestUrlString: String, parameters: [String: String]?, complete: @escaping(_ json: Any?, _ isSuccess: Bool) -> Void) {
        
        guard let token = userAccount.access_token
            else {
                
                // 没有token了，需要发送通知给MainViewController， 并且展示登录界面
                print("没有token，请重新登录")
                NotificationCenter.default.post(name: .WBUserShouldLogon, object: nil)
                
                complete(nil, false)
                return
        }
        
        var parameters = parameters
        
        if parameters == nil {
            parameters = [String: String]()
        }
        
        parameters!["access_token"] = token
        request(URLString: requestUrlString, parameters: parameters!, complete: complete)
    }
    
    // 销毁
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(self, name: .WBUserShouldLogon, object: nil)
    }
    
    // 封装 get / post 请求
    func request(method: RequestMethod = .GET, URLString: String, parameters: [String: String], complete: @escaping(_ json: Any?, _ isSuccess: Bool) -> Void) {
        
        let success = { (dataTask: URLSessionDataTask, json: Any?) in
            complete(json, true)
        }
        
        let failure = { (dataTask: URLSessionDataTask?, error: Error) in
            
            // 针对 403 处理用户 token 过期
            // 对于测试用户(应用程序还没有提交给新浪微博审核)每天的刷新量是有限的！
            // 超出上限，token 会被锁定一段时间
            // 解决办法，新建一个应用程序！
            if (dataTask?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("token 已过期！请重新登录")
                // FIXME: 发送重新登录通知
            }
            
            complete(nil, false)
        }
        
        if method == .GET {
            // get 方法
            get(URLString, parameters: parameters, headers: nil, progress: nil, success: success, failure: failure)
        } else {
            // post 方法
            post(URLString, parameters: parameters, headers: nil, progress: nil, success: success, failure: failure)
        }
    }
}
