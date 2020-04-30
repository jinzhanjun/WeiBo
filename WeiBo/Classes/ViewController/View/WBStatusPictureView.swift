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
    var viewModel: WBStatusViewModel? {
        didSet {
            // 重新调整单张视图的大小
            resizeImageView()
            // 设定url，加载图片
            guard let urls = viewModel?.pic_urls else { return }
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
        if viewModel?.pic_urls?.count == 1 {
            
            let picSize = viewModel?.picViewSize ?? CGSize()
            // 获取第一个imageView
            let imageView = subviews[0]
            let rect = CGRect(x: PictureViewOutMargin,
                              y: PictureViewOutMargin,
                              width: picSize.width - 2 * PictureViewOutMargin,
                              height: picSize.height)
            // 设置单张配图的图片大小
            imageView.frame = rect
        } else {
            // 多图（无图）情况恢复原状
            // 计算图片frame
            let rect = CGRect(x: PictureViewOutMargin,
                              y: PictureViewOutMargin,
                              width: PictureViewImageWidth,
                              height: PictureViewImageHeiht)
            
            subviews[0].frame = rect
            // 设置图片视图的高度
        }
        pictureViewHeight.constant = viewModel?.picViewSize.height ?? 0
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
            
            // 设置填充模式
            imageView.contentMode = .scaleAspectFill
            
            imageView.clipsToBounds = true
            
//            imageView.backgroundColor = UIColor.red
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
            
            pictureViewHeight.constant = viewModel?.picViewSize.height ?? 0
        }
    }
    

}
