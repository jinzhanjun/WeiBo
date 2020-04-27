//
//  WBStatusListViewModel.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/7.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation
import YYModel
import SDWebImage

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
            
//            for model in array {
//                model.statusModel.pic_urls?.forEach{  }
//            }
            // GCD，监听异步加载是否已经完成，为了提前计算行高，而不是动态计算行高，提升性能！
            self.cacheSingleImage(modelArray: self.statusModelArray, finished: complete)
            
            // 完成回调
//            complete(isSuccess, true)
        }
    }
    
    /// 缓存单张配图，调整行高，单张配图要显示的更大。
    private func cacheSingleImage(modelArray: [WBStatusViewModel], finished: @escaping(_ isSuccess: Bool, _ shouldRefresh: Bool) -> Void) {
        // 缓存单张配图的总大小
        var siglePicSize = 0
        
        // 设置调度组，监听异步执行
        let group = DispatchGroup()
        
        modelArray.forEach{ statusViewModel in
            
            // 判断是否是单张图片, 如果不是1张图片，就返回
            if statusViewModel.statusModel.pic_urls?.count != 1 { return }
            
//            print(statusViewModel.statusModel.pic_urls?.count)
            
            // 到此为止，有且仅有一张图片
            guard let urlStr = statusViewModel.statusModel.pic_urls?[0].thumbnail_pic else { return }
            // 单张配图url
            let url = URL(string: urlStr)
            
            // 调度组进入，监听闭包
            group.enter()
            // > 下载图像
            // 1) downloadImage 是 SDWebImage 的核心方法
            // 2) 图像下载完成之后，会自动保存在沙盒中，文件路径是 URL 的 md5
            // 3) 如果沙盒中已经存在缓存的图像，后续使用 SD 通过 URL 加载图像，都会加载本地沙盒地图像
            // 4) 不会发起网路请求，同时，回调方法，同样会调用！
            // 5) 方法还是同样的方法，调用还是同样的调用，不过内部不会再次发起网路请求！
            // *** 注意点：如果要缓存的图像累计很大，要找后台要接口！
            SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { (image, _, _, _, isSuccess, _) in
                
                // 根据图像大小重新设置单张配图cell的行高！
                guard let image = image,
                    let data = image.pngData()
                else { return }
                
                // 缓存单张图片数量叠加
                siglePicSize += data.count
                
                // 重新设置单张配图的pictureViewHeight
                statusViewModel.resizeSiglePicView(with: image)
                
                // 调度组出列
                group.leave()
            }
        }
        
        // 异步执行结束后，发送消息
        group.notify(queue: DispatchQueue.main) {
            
            print("共缓存： \(siglePicSize)KB")
            // 缓存完成，回调（配置模型，列表视图加载内容）
            finished(true, true)
        }
    }
}
