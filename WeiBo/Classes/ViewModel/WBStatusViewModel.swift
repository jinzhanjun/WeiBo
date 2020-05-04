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
    
    /// 配图的urls
    var pic_urls: [PictureModel]? {
        
        // 如果有转发微博就返回转发微博的url；如果没有就返回原文的urls
        return statusModel.retweeted_status?.pic_urls ?? statusModel.pic_urls
    }
    
    /// 配图视图的大小
    var picViewSize = CGSize()
    
    /// 行高
    var cellHeight: CGFloat?
    
    /// 转发数量
    var reposts_count: Int = 0
    /// 评论数量
    var comments_count: Int = 0
    /// 赞数量
    var attitudes_count: Int = 0
    
    init(model: StatusModel) {
        self.statusModel = model
        
        // 判断会员等级
        if model.user?.mbrank ?? 0 > 0 {
            let image = UIImage(named: "common_icon_membership_level" + String(model.user?.mbrank ?? 0))
            
            memberIcon = image
        }
        
        // 如果0 张图片，就返回CGSize(0, 0)
        picViewSize = picViewSizeCalculator(with: pic_urls?.count ?? 0)
        
        cellHeightCalculate()
        
        print("picViewSize: \(picViewSize)")
        
        // 转发、评论、赞的数量
        reposts_count = model.reposts_count
        comments_count = model.comments_count
        attitudes_count = model.attitudes_count
    }
    
    /// 计算行高
    private func cellHeightCalculate() {
        let margin: CGFloat = 12
        var height: CGFloat = 0
        
        // 顶部分割视图
        height += 12
        // 间距
        height += margin
        // 头像高度
        height += 34
        // 间距
        height += margin
        
        // 计算文本高度
        height += ((statusModel.text ?? "") as NSString).boundingRect(
            with: CGSize(width: UIScreen.cz_screenWidth() - 2 * PictureViewOutMargin,height: CGFloat(MAXFLOAT)),
            options: [.usesLineFragmentOrigin],
            attributes: [.font: UIFont.systemFont(ofSize: 15)],
            context: nil).height
        
        if statusModel.retweeted_status != nil {
            height += 12
            
            height += 12
            
            let text = (statusModel.retweeted_status?.text ?? "") + "@：" + (statusModel.user?.screen_name ?? "")
            
            height += (text as NSString).boundingRect(
                with: CGSize(width: UIScreen.cz_screenWidth() - 2 * PictureViewOutMargin, height: CGFloat(MAXFLOAT)),
                options: [.usesLineFragmentOrigin],
                attributes: [.font: UIFont.systemFont(ofSize: 14)],
                context: nil).height
        }
        
        height += picViewSize.height
        
        height += PictureViewInnerMargin
        
        height += 35
        
        cellHeight = height
    }
    
    // 重新调整单张视图的大小
    func resizeSiglePicView(with image: UIImage) {
        
        var size = image.size
        
        let maxWidth: CGFloat = UIScreen.cz_screenWidth() - 2 * PictureViewOutMargin
        let minWidth: CGFloat = 40
        
        // 过宽图像处理
        if size.width > maxWidth {
            // 设置最大宽度
            size.width = maxWidth
            // 等比例调整高度
            size.height = size.width * image.size.height / image.size.width
        }
        
        // 过窄图像处理
        if size.width < minWidth {
            size.width = minWidth
            
            // 要特殊处理高度，否则高度太大，会印象用户体验
            size.height = size.width * image.size.height / image.size.width / 4
        }
        
        // 过高图片处理，图片填充模式就是 scaleToFill，高度减小，会自动裁切
        if size.height > 360 {
            size.height = 360
        }
        
        // 特例：有些图像，本身就是很窄，很长！-> 定义一个 minHeight，思路同上！
        // 在工作中，如果看到代码中有些疑惑的分支处理！千万不要动！
        
        // 注意，尺寸需要增加顶部的 12 个点，便于布局
        size.height += PictureViewOutMargin
        
        
//        statusModel.pic_urls?[0].siglePicSize = image.size
        
//        let height = (pic_urls?[0].siglePicSize ?? CGSize()).height + PictureViewOutMargin
        
        picViewSize = CGSize(width: UIScreen.cz_screenWidth(), height: size.height)
        
        print(" 图像大小为：  \(image.size)")
        print(" 图像视图大小为： \(size)")
        
        cellHeightCalculate()
    }
    
    /// 根据配图数量计算配图视图高度
    private func picViewSizeCalculator(with count: Int) -> CGSize {
        
        if count != 0 {
            
            // 计算行数
            let rowCount = (count - 1) / 3 + 1
            
            // 计算配图宽高
            let pictureWidth = (UIScreen.cz_screenWidth() - 2 * (PictureViewInnerMargin + PictureViewOutMargin)) / 3
            
            // 配图宽高相等
            let pictureHeight = pictureWidth
            
            // 计算配图视图高度
            let height = CGFloat(rowCount) * pictureHeight + PictureViewOutMargin + CGFloat(rowCount - 1) * PictureViewInnerMargin
            // 配图视图宽度
            let width = UIScreen.cz_screenWidth() - 2 * PictureViewOutMargin
            return CGSize(width: width, height: height)
        }
        return CGSize(width: 0, height: 0)
    }
}
