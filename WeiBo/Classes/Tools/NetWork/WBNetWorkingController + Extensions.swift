//
//  WBNetWorkingController + Extensions.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/7.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation
import YYModel


extension WBNetWorkingController {
    
    /// 封装发布微博
    func statusUpdate(parameters: [String: String]?, complete: @escaping (_ json: Any?, _ isSuccess: Bool) -> Void) {
        
        tokenRequest(method: .POST, requestUrlString: StatusUpdateUrl, parameters: parameters, complete: complete)
    }
    
    func requestUnreadCount(completion: @escaping(Int) -> Void) {
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        
        let parameters = ["uid": Uid]
        
        tokenRequest(requestUrlString: urlString, parameters: parameters) { (json, isSuccess) in
            
            if let jsonDic = json as? [String: Any], let unreadCount = jsonDic["status"] as? Int {
                completion(unreadCount)
            }else {
                return
            }
        }
    }
}

/// 用来封装提取statuses数据的方法
extension WBNetWorkingController {
    
    /// 获取当前登录用户及其所关注用户的最新微博
    /// - Parameters:
    ///   - since_id: 比since_id大的微博
    ///   - max_id: 比max_id小的微博
    ///   - complete: 完成回调
    func requestStatusList( since_id:Int64 = 0, max_id: Int64 = 0, complete: @escaping(Any?, Bool) -> Void) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let parameters = ["since_id": "\(since_id)", "max_id": "\((max_id > 0) ? max_id - 1 : 0)"]
        
        let jsonComplete = { (json: Any?, isSuccess: Bool) in
            
            if json == nil {
                print("无法获取json")
                complete(nil, isSuccess)
            }
            
            if let result = json as? [String: Any],
                let jsonStatuses = result["statuses"]
            {
                complete(jsonStatuses, isSuccess)
                
            }
            
        }
        tokenRequest(requestUrlString: urlString, parameters: parameters, complete: jsonComplete)
    }
}

/// Oauth 授权请求
extension WBNetWorkingController {
    /// 通过Oauth获取token的请求
    func tokenRequest(code: String, complete: @escaping(_ isSuccess: Bool)-> ()) {
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let parameter = [
            "client_id": Uid,
            "client_secret": WBSecret,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": WBRedirect_URI,
        ]
        
        request(method: .POST, URLString: urlString, parameters: parameter) { [weak self] (json, isSuccess) in
            
            // 数据转模型
            self?.userAccount.yy_modelSet(with: (json as? [String: Any]) ?? [:])
            
            
            // 用户信息请求加载
            self?.userInfoRequest(completion: { (userInfoDic) in
                self?.userAccount.yy_modelSet(with: userInfoDic)
                
                
//                print(self?.userAccount)
                // 加载完成，回调给控制器（WBLoginViewController）
                complete(isSuccess)
                self?.userAccount.save()
            })
        }
    }
}

/// 用户信息请求
extension WBNetWorkingController {
    
    // 封装用户信息请求
    private func userInfoRequest(completion: @escaping([String: Any])->()) {
        
        let paramaters = ["uid": String(userAccount.uid)]
        
        tokenRequest(requestUrlString: UserInfoUrl, parameters: paramaters) { (json, isSuccess) in
            
            guard let userInfoDic = json as? [String: Any] else { return }
            completion(userInfoDic)
        }
    }
}
