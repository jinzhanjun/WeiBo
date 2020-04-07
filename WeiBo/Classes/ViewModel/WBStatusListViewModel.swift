//
//  WBStatusListViewModel.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/7.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation
import YYModel

class WBStatusListViewModel {
    
    // 创建微博消息模型数组
    lazy var statusModelArray = [StatusModel]()
    
    // 加载数据
    func setupModel(complete: @escaping(Bool) -> Void) {
        
        
        let since_id = statusModelArray.first?.id ?? 0
        
        WBNetWorkingController.shared.requestStatusList(since_id: since_id) { (json, isSuccess) in
            // 字典转模型
            guard let array = NSArray.yy_modelArray(with: StatusModel.self, json: json ?? []) as? [StatusModel]
                else {
                    complete(isSuccess)
                    return
            }
            
            // 拼接数据
            self.statusModelArray = array + self.statusModelArray
            
            print("加载了 \(array.count) 条微博")
            
            // 完成回调
            complete(isSuccess)
        }
    }
}
