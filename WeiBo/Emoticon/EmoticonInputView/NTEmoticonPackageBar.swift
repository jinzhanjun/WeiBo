//
//  NTEmoticonPackageBar.swift
//  emojiInput
//
//  Created by jinzhanjun on 2020/5/19.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class NTEmoticonPackageBar: UIView {
    
    /// 重新布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    /// 设置界面，添加图片包的按钮
    private func setupUI() {
        
        // 获取表情包数据
        let emojiPakeges = EmoticonManager.shared.emojiListModel
        // 计算按钮宽高
        let width = bounds.width / CGFloat(emojiPakeges.count)
        let height = bounds.height
        
        // 获取表情包 bundle
        guard let bundlePath = Bundle.main.path(forResource: "HMEmoticon", ofType: ".bundle"),
            let emojiBundle = Bundle(path: bundlePath)
            else { return }
        
        // 遍历表情包
        for (i, model) in emojiPakeges.enumerated() {
            // 创建按钮
            let btn = UIButton()
            // 设置按钮标题
            btn.setTitle(model.groupName, for: .normal)
            
            // 设置按钮背景图片
            let imageName = "compose_emotion_table_" + (model.bgImageName ?? "") + "_normal"
            let imageHighlightedName = "compose_emotion_table_" + (model.bgImageName ?? "") + "_selected"
            var image = UIImage(named: imageName, in: emojiBundle, with: nil)
            var imageHL = UIImage(named: imageHighlightedName, in: emojiBundle, with: nil)
            
            // 记录背景图片大小
            let size = image?.size ?? CGSize()
            
            // 设置图片拉伸位置
            let edgeInsets = UIEdgeInsets(top: 0.5 * size.height,
                                          left: 0.5 * size.width,
                                          bottom: 0.5 * size.height,
                                          right: 0.5 * size.width)
            // 拉伸图片
            image = image?.resizableImage(withCapInsets: edgeInsets, resizingMode: .stretch)
            imageHL = imageHL?.resizableImage(withCapInsets: edgeInsets, resizingMode: .stretch)
            // 设置背景图片
            btn.setBackgroundImage(image, for: .normal)
            btn.setBackgroundImage(imageHL, for: .selected)
            
            // 设置按钮 frame
            let x = CGFloat(i) * width
            btn.frame = CGRect(x: x, y: 0, width: width, height: height)
            // 添加按钮
            addSubview(btn)
        }
    }
}
