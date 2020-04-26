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
    
    var statusModel: StatusModel? {
        didSet {
            
            
            guard let urls = statusModel?.pic_urls else { return }
            
            /// 隐藏所有imageView
            subviews.forEach{ $0.isHidden = true }
            
            
            /// 重新设置配图视图的高度
            pictureViewHeight.constant = heightCalculator(with: urls.count)
            
            // 设置配图图片
            for i in 0..<urls.count {
                
                // 显示图片
                subviews[i].isHidden = false
                
                if let sv = subviews[i] as? UIImageView,
                    let urlStr = urls[i].thumbnail_pic
                {
                    let url = URL(string: urlStr)
                    SDWebImageManager.shared.loadImage(with: url, options: [], context: nil, progress: nil) { (image, _, _, _, _, _) in
                        sv.image = image
                    }
                }
            }
        }
    }
    
    
     @IBOutlet weak var pictureViewHeight: NSLayoutConstraint!
    
    /// 从nib中加载
    override func awakeFromNib() {
        setupUI()
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
            
            // 计算图片宽高
            let width = (UIScreen.cz_screenWidth() - 2 * (PictureViewOutMargin + PictureViewInnerMargin)) / CGFloat(count)
            
            // 计算图片高度
            let height = width
            
            // 计算图片frame
            let rect = CGRect(x: PictureViewOutMargin,
                              y: PictureViewOutMargin,
                              width: width,
                              height: height)
            
            let offsetX = CGFloat(columnValue - 1) * (width + PictureViewInnerMargin)
            let offsetY = CGFloat(rowValue - 1) * (height + PictureViewInnerMargin)
            
            
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
