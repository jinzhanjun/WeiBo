//
//  WBStatusListViewModel.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/7.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation
import YYModel

let loadStatusMaxTime = 3

class WBStatusListViewModel {
    
    var loadStatusTime = 0
    
    // 创建微博消息模型数组
    lazy var statusModelArray = [StatusModel]()
    
    // 加载数据
    func setupModel(pullUp: Bool, complete: @escaping(_ isSuccess: Bool, _ shouldRefresh: Bool) -> Void) {
        
        if loadStatusTime > loadStatusMaxTime {
            complete(false, false)
            return
        }
        
        let since_id = pullUp ? 0 : (statusModelArray.first?.id ?? 0)
        let max_id = !pullUp ? 0 : (statusModelArray.last?.id ?? 0 )
        
        WBNetWorkingController.shared.requestStatusList(since_id: since_id, max_id: max_id) { (json, isSuccess) in
            // 字典转模型
            guard let array = NSArray.yy_modelArray(with: StatusModel.self, json: json ?? []) as? [StatusModel]
                else {
                    complete(isSuccess, false)
                    return
            }
            
            print("加载了 \(array.count) 条微博")
            
            // 若没有获取到最新数据
            if array.count == 0 {
                complete(isSuccess, false)
                self.loadStatusTime += 1
                return
            }
            
            // 拼接数据
            if pullUp {
                self.statusModelArray += array
            } else {
                self.statusModelArray = array + self.statusModelArray
            }
            // 完成回调
            complete(isSuccess, true)
        }
    }
}
