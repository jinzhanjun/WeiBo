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
    // 微博ID
    @objc var id: Int64 = 0
    // 微博内容
    @objc var text: String?
    
//    init(id: Int64, text: String) {
//        self.id = id
//        self.text = text
//    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
