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
    
    func requestStatusList(parameters: [String: String], complete: @escaping(Any?, Bool) -> Void) {
        
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
        requestWeiBo(parameters: parameters, complete: jsonComplete)
    }
}
