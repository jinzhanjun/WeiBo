//
//  UIButton+Extension.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/4.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 创建UIBarButtonItem
    /// - Parameters:
    ///   - title: 标题
    ///   - fontSize: 字体大小
    ///   - normalColor: 常规颜色
    ///   - highlightedColor: 高亮颜色
    ///   - target: 监听目标
    ///   - action: 监听方法
    ///   - event: 触发事件
    convenience init(title: String, fontSize: CGFloat = 16, normalColor: UIColor = UIColor.systemBlue, highlightedColor: UIColor = UIColor.orange, target: Any?, action: Selector, event: UIControl.Event, imageName: String? = nil, highlightedName: String? = nil) {
        let buttonItem: UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: normalColor, highlightedColor: highlightedColor)
        buttonItem.addTarget(target, action: action, for: event)
        if imageName != nil {
            buttonItem.setImage(UIImage(named: imageName!), for: .normal)
        }
        if highlightedName != nil {
            buttonItem.setImage(UIImage(named: highlightedName!), for: .highlighted)
        }
        
        buttonItem.sizeToFit()
        self.init(customView: buttonItem)
    }
}
