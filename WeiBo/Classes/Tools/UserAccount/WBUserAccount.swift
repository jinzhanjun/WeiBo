//
//  WBUserAccount.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/16.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

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
    
    override var description: String {
        return yy_modelDescription()
    }

}
