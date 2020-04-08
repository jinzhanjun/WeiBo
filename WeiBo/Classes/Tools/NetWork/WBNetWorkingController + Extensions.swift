//
//  WBNetWorkingController + Extensions.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/7.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation

/// 用来封装提取statuses数据的方法
extension WBNetWorkingController {
    
    func requestStatusList(since_id: Int64 = 0, max_id: Int64 = 0, complete: @escaping(Any?, Bool) -> Void) {
        
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
