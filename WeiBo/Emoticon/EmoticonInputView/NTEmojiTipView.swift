//
//  NTEmojiTipView.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/5/25.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit
import pop

class NTEmojiTipView: UIImageView {
    
    /// 上一个表情模型
    var preEmojiModel: EmojiModel?
    
    /// 懒加载表情视图（这里使用需要使用button，如果使用imageView的话，无法设置图像）
    lazy var emojiImageView = UIButton()
    // 设置表情模型数据
    var emojiModel: EmojiModel? {
        didSet {
            
            if emojiModel != preEmojiModel {
                
                // 记录上一个表情模型
                preEmojiModel = emojiModel
                
                // 设置表情图像
                emojiImageView.setImage(emojiModel?.image, for: .normal)
                // 自动调整大小
                emojiImageView.sizeToFit()
                emojiImageView.center = CGPoint(x: bounds.width / 2, y: 10)
                emojiImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
                
                let springPop = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                springPop?.fromValue = 50
                springPop?.toValue = 10
                
                springPop?.springBounciness = 10
                springPop?.springSpeed = 20
                
                emojiImageView.layer.pop_add(springPop, forKey: nil)
            }
        }
    }
    
    /// 初始化方法，仅仅就是为了表情提示这一个功能。
    init() {
        // 获取bundle，
        let bundle = EmoticonManager.shared.bundle
        // 获取 image
        let image = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        
        super.init(image: image)
        
        // 设置锚点
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
        
        // 添加表情视图
        addSubview(emojiImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
