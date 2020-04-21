//
//  WBUser.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/21.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation

class WBUser: NSObject {
    
    override var description: String {
        return yy_modelDescription()
    }
    /// 用户昵称
    @objc var screen_name: String?
    /// 用户头像
    @objc var profile_image_url: String?
    
    /// 认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    @objc var verified_type: Int = 0
    /// 会员等级 0-6
    @objc var mbrank: Int = 0
    
    
    
}
