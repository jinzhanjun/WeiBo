//
//  WBNetWorkingController + Extensions.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/7.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation


extension WBNetWorkingController {
    
    func requestUnreadCount(completion: @escaping(Int) -> Void) {
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        
        let parameters = ["uid": uid!]
        
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

