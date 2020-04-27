//
//  PictureModel.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/26.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation

class PictureModel: NSObject {
    /// 图片url 地址---新浪返回的缩略图令人发指
    @objc var thumbnail_pic: String? {
        didSet {
            
            // 设置大图地址
            large_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/large/")
            
            // 替换缩略图地址
            thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        }
    }
    
    // 大图
    var large_pic: String?
    
    // 单张配图的大小
    var siglePicSize: CGSize?
}
