//
//  WBStatusPictureView.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/26.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit
import SDWebImage
import AFNetworking

class WBStatusPictureView: UIView {
    // 微博模型
    var statusModel: StatusModel? {
        didSet {
            // 重新调整单张视图的大小
            resizeImageView()
            // 设定url，加载图片
            guard let urls = statusModel?.pic_urls else { return }
            picUrls = urls
        }
    }
    
    // 图片的url
    var picUrls: [PictureModel]? {
        didSet {
            // 隐藏所有imageView
            subviews.forEach{ $0.isHidden = true }
            
            var index = 0
            // 设置配图图片
            for i in 0..<(picUrls?.count ?? 0) {
                
                // 如果是四张图片，则跳过设置第三张图片，直接设置第四张、第五张。
                if picUrls?.count == 4 && i == 2 {
                    index += 1
                }
                
                if let sv = subviews[index] as? UIImageView,
                    let urlStr = picUrls?[i].thumbnail_pic,
                    let url = URL(string: urlStr)
                {
                    // 设置imageVie中image的填充模式 等比例填满
                    sv.contentMode = .scaleAspectFill
                    
                    // 超出部分裁掉
                    sv.clipsToBounds = true
                    
                    
                    // SDWebImage框架从网络加载数据，
                    // 如果url内容已经被缓存了，则不再通过网络加载！
                    sv.setImageWith(url)
                    // 显示图片
                    subviews[index].isHidden = false
                    index += 1
                }
            }
        }
    }
    
    
     @IBOutlet weak var pictureViewHeight: NSLayoutConstraint!
    
    /// 从nib中加载
    override func awakeFromNib() {
        setupUI()
    }
    
    /// 根据是否为单张视图，调整内部imageView的大小
    func resizeImageView() {
        //MARK: - 单独设置单张配图的imageView的大小
        if statusModel?.pic_urls?.count == 1 {
            
            let picSize = statusModel?.pic_urls?[0].siglePicSize ?? CGSize()
            // 获取第一个imageView
            let imageView = subviews[0]
            let rect = CGRect(x: PictureViewOutMargin,
                              y: PictureViewOutMargin,
                              width: picSize.width,
                              height: picSize.height)
            // 设置单张配图的图片大小
            imageView.frame = rect
            pictureViewHeight.constant = 2 * PictureViewOutMargin + picSize.height
        } else {
            // 多图（无图）情况恢复原状
            
            // 计算图片frame
            let rect = CGRect(x: PictureViewOutMargin,
                              y: PictureViewOutMargin,
                              width: PictureViewImageWidth,
                              height: PictureViewImageHeiht)
            
            subviews[0].frame = rect
            // 设置图片视图的高度
            pictureViewHeight.constant = heightCalculator(with: statusModel?.pic_urls?.count ?? 0)
        }
    }
    
    /// 设置界面
    // 1. Cell 中所有的控件都是提前准备好
    // 2. 设置的时候，根据数据决定是否显示
    // 3. 不要动态创建控件
    func setupUI() {
        
        // 超出边界被裁掉
        clipsToBounds = true
        
        // 设置配图视图背景与父视图背景颜色一样
        backgroundColor = superview?.backgroundColor
        
        // 循环创建9个UIImage
        let count = 3
        for i in 0..<count * count {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.red
            // 计算所在行数
            let rowValue = i / 3 + 1
            // 计算所在列数
            let columnValue = i % 3 + 1
//
//            // 计算图片宽高
//            let width = (UIScreen.cz_screenWidth() - 2 * (PictureViewOutMargin + PictureViewInnerMargin)) / CGFloat(count)
//
//            // 计算图片高度
//            let height = width
            
            // 计算图片frame
            let rect = CGRect(x: PictureViewOutMargin,
                              y: PictureViewOutMargin,
                              width: PictureViewImageWidth,
                              height: PictureViewImageHeiht)
            // 根据图片所在的行列，计算偏移量
            let offsetX = CGFloat(columnValue - 1) * (PictureViewImageWidth + PictureViewInnerMargin)
            let offsetY = CGFloat(rowValue - 1) * (PictureViewImageHeiht + PictureViewInnerMargin)
            
            
            // 设置图片frame
            imageView.frame = rect.offsetBy(dx: offsetX, dy: offsetY)
            
            // 添加子视图
            addSubview(imageView)
        }
    }
    
    /// 根据配图数量计算高度
    private func heightCalculator(with count: Int) -> CGFloat {
        
        if count != 0 {
            
            // 计算行数
            let rowCount = (count - 1) / 3 + 1
            // 计算列数
//            let columnCount = (count - 1) % 3 + 1
            
            // 计算配图宽高
            let pictureWidth = (UIScreen.cz_screenWidth() - 2 * (PictureViewInnerMargin + PictureViewOutMargin)) / 3
            
            // 配图宽高相等
            let pictureHeight = pictureWidth
            
            // 计算配图视图高度
            let height = CGFloat(rowCount) * pictureHeight + 2 * PictureViewOutMargin + CGFloat(rowCount - 1) * PictureViewInnerMargin
            
            return height
        }
        return CGFloat(0)
    }
}
