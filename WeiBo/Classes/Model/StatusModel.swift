//
//  statusModel.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/7.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation
import YYModel

class StatusModel: NSObject {
    
    /// Swift 4 里面继承NSObject 不再默认在变量前 添加@objc; YYModelMeta中的_keyMappedCount获取不到不带@objc的变量，所以_keyMappedCount一直是0，转出来的model 也就是 nil；
    /// 微博ID
    @objc var id: Int64 = 0
    /// 微博内容
    @objc var text: String?
    /// 用户信息
    @objc var user: WBUser?
    
    /// 微博来源
    @objc var source: String?
    ///   转发数
    @objc var reposts_count: Int = 0
    ///  评论数
    @objc var comments_count: Int = 0
    ///   表态数
    @objc var attitudes_count: Int = 0
    
    override var description: String {
        return yy_modelDescription()
    }
}
