//
//  UIImage+Extension.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/21.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation

/// 通过图形上下文重新绘制图像
extension UIImage {
    
    /// 通过图形上下文重新绘制图像
    /// - Parameter size: 绘制大小
    /// - Returns: 重新调整大小后的图像
    func resizedImage(with size: CGSize) -> UIImage? {
        
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let rect = CGRect(origin: .zero, size: size)
        
        // 设置背景颜色
        UIColor.white.setFill()
        UIRectFill(rect)
        // 裁切形状
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        
        // 画图像
        self.draw(in: rect)
        
        // 描边
        UIColor.darkGray.setStroke()
        path.lineWidth = 2
        path.stroke()
        
        // 获取图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭图形上下文
        UIGraphicsEndImageContext()
        
        return image
    }
}

/// 通过SdWebImage从网络获取图像，并且设置占位图像，根据size重新绘制图像。
extension UIImageView {
    
    ///通过SdWebImage从网络获取图像，并且设置占位图像，根据size重新绘制图像
    /// - Parameters:
    ///   - url: 图像url地址
    ///   - size: 绘制大小
    ///   - image: 占位图像
    ///   - isAvatar: 是否为头像
    func jj_image(with url: URL?, by size: CGSize?, placeholderImage image: UIImage?, isAvatar: Bool = true) {
        
        let imageSize = size ?? bounds.size
        
        sd_setImage(with: url, placeholderImage: image, options: []) { [weak self] (image, _, _, _) in
            
            if isAvatar {
                let image = image?.resizedImage(with: imageSize)
                self?.image = image
            }
        }
    }
}
