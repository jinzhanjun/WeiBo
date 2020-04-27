//
//  WBStatusViewModel.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/21.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation
import SDWebImage

class WBStatusViewModel {
    
    /// 模型
    var statusModel: StatusModel
    /// 头像
    var profileImage: UIImage?
    /// 会员图标
    var memberIcon: UIImage?
    /// 昵称标签
    var nameLabel: UILabel?
    
    init(model: StatusModel) {
        self.statusModel = model
        
        // 判断会员等级
        if model.user?.mbrank ?? 0 > 0 {
            let image = UIImage(named: "common_icon_membership_level" + String(model.user?.mbrank ?? 0))
            
            memberIcon = image
        }
        
        // 通过model 的 profile_image_url 获取用户头像
        
    }
    
    // 重新调整单张视图的大小
    func resizeSiglePicView(with image: UIImage) {
        statusModel.pic_urls?[0].siglePicSize = image.size
    }
}
