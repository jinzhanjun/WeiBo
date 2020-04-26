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
    lazy var statusModelArray = [WBStatusViewModel]()
    
    // 加载数据
    func setupModel(pullUp: Bool, complete: @escaping(_ isSuccess: Bool, _ shouldRefresh: Bool) -> Void) {
        
        if loadStatusTime > loadStatusMaxTime {
            complete(false, false)
            return
        }

        let since_id = pullUp ? 0 : (statusModelArray.first?.statusModel.id ?? 0)
        let max_id = !pullUp ? 0 : (statusModelArray.last?.statusModel.id ?? 0 )
        
        WBNetWorkingController.shared.requestStatusList(since_id: since_id, max_id: max_id) { (json, isSuccess) in
            
            // 如果加载不成功，直接返回
            if !isSuccess {
                complete(false, false)
                return
            }
            
            // 创建模型数组
            var array = [WBStatusViewModel]()
            
            // 遍历字典，字典转模型
            let jsonDict = json as? [[String: Any]] ?? []
            
            for dict in jsonDict {
                // 字典转模型
                let model = StatusModel()
                
                model.yy_modelSet(withJSON: dict)
                
                let viewModel = WBStatusViewModel(model: model)
                array.append(viewModel)
            }
            
            print("加载了 \(array.count) 条微博")

            // 若没有获取到最新数据
            if pullUp && array.count == 0 {
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
