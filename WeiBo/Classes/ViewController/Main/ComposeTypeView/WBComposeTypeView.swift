//
//  WBComposeTypeView.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/5/8.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class WBComposeTypeView: UIControl {
    
    /// 图像视图
    @IBOutlet weak var imageView: UIImageView!
    /// 标签视图
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 点击后需要展现的控制器名称字符串
    var clsName: String?
    
    /// 类方法，返回实例
    class func composeTypeView() -> WBComposeTypeView {
        let nib = UINib(nibName: "WBComposeTypeView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeView
    }
}
